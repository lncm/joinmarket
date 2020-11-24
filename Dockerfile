# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

ARG VERSION=v0.7.2
ARG REPO=https://github.com/JoinMarket-Org/joinmarket-clientserver
ARG USER=joinmarket
ARG DIR=/data/

FROM python:3.8.5-slim-buster AS final

LABEL maintainer="nolim1t (hello@nolim1t.co)"

ARG VERSION
ARG REPO

# Setup dependencies
RUN apt-get update && apt-get -y install python3-dev python3-pip git build-essential automake pkg-config libtool libffi-dev libssl-dev libgmp-dev libsodium-dev pwgen
WORKDIR /
RUN git clone https://github.com/bitcoin-core/secp256k1.git
RUN git clone $REPO

# Build secp256k1
WORKDIR /secp256k1
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

# Copy from base dir
# namely genwallet.py which doesn't exist yet
COPY ./bins/*.py /usr/local/bin
# Entrypoint for joinmarket
COPY ./bins/jm-entrypoint.sh /usr/local/bin

# Joinmarket root
WORKDIR /joinmarket-clientserver
# If version is not master then checkout a different branch
RUN git checkout $VERSION

# Copy some useful utils into /usr/local/bin
RUN cp scripts/yg-privacyenhanced.py /usr/local/bin
RUN cp scripts/wallet-tool.py /usr/local/bin
RUN cp scripts/add-utxo.py /usr/local/bin
RUN cp scripts/sendpayment.py /usr/local/bin
RUN cp scripts/sendtomany.py /usr/local/bin
RUN cp scripts/receive-payjoin.py /usr/local/bin
RUN cp scripts/convert_old_wallet.py /usr/local/bin
RUN cp scripts/tumbler.py /usr/local/bin

RUN pip install -r "requirements/base.txt"

ARG USER
ARG DIR

RUN adduser --disabled-password \
            --home "$DIR" \
            --gecos "" \
            "$USER"


USER $USER
RUN mkdir -p $DIR/.joinmarket

# Copy templates to home directory
COPY ./templates/joinmarket.cfg-dist $DIR

WORKDIR $DIR

# Default to joinmarketd
#ENTRYPOINT ["/joinmarket-clientserver/joinmarketd.py", "27183" , "0" , "127.0.0.1"]
ENTRYPOINT ["jm-entrypoint.sh"]

