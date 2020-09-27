# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

ARG VERSION=v0.7.0
ARG REPO=https://github.com/JoinMarket-Org/joinmarket-clientserver
ARG USER=joinmarket
ARG DIR=/data/

FROM python:3.8.5-slim-buster AS final

LABEL maintainer="nolim1t (hello@nolim1t.co)"

ARG VERSION
ARG REPO

RUN apt-get update && apt-get -y install python3-dev python3-pip git build-essential automake pkg-config libtool libffi-dev libssl-dev libgmp-dev libsodium-dev
WORKDIR /
RUN git clone https://github.com/bitcoin-core/secp256k1.git
RUN git clone $REPO

# Build secp256k1
WORKDIR /secp256k1
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

# Joinmarket root
WORKDIR /joinmarket-clientserver
RUN git checkout $VERSION

RUN pip install -r "requirements/base.txt"

ARG USER
ARG DIR

RUN adduser --disabled-password \
            --home "$DIR" \
            --gecos "" \
            "$USER"


USER $USER
RUN mkdir -p $DIR/.joinmarket

WORKDIR $DIR

# Default to joinmarketd
ENTRYPOINT ["/joinmarket-clientserver/scripts/joinmarketd.py"]
