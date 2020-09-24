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

FROM python:3.8.5-slim-buster AS builder

ARG VERSION
ARG REPO

RUN apt-get update && apt-get -y install python3-dev python3-pip git build-essential automake pkg-config libtool libffi-dev libssl-dev libgmp-dev libsodium-dev
WORKDIR /
RUN git clone $REPO

# Joinmarket root
WORKDIR /joinmarket-clientserver
RUN git checkout $VERSION

RUN pip install -r "requirements/base.txt"


FROM python:3.8.5-slim-buster as final

LABEL maintainer="nolim1t (hello@nolim1t.co)"

ARG USER
ARG DIR

RUN adduser --disabled-password \
            --home "$DIR" \
            --gecos "" \
            "$USER"

USER $USER
RUN mkdir -p $DIR/.joinmarket

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder  /usr/local/lib/python3.8 /usr/local/lib/python3.8

ENTRYPOINT ["/usr/local/bin/python3"]

