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
ARG DATA=/data/
#ARG LIBSECP256K1=https://github.com/bitcoin-core/secp256k1/archive/0d9540b13ffcd7cd44cc361b8744b93d88aa76ba.tar.gz
#ARG LIBSODIUM=https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz

FROM python:3.8.5-slim-buster AS builder

ARG VERSION
ARG REPO
#ARG LIBSECP256K1
#ARG LIBSODIUM

#RUN apt update && apt install -y git build-essential virtualenv python3-dev pkg-config automake libtool libgmp-dev libffi-dev curl python3-pip wget libsodium-dev libsecp256k1-dev libssl-dev
RUN apt-get update && apt-get -y install python3-dev python3-pip git build-essential automake pkg-config libtool libffi-dev libssl-dev libgmp-dev libsodium-dev
WORKDIR /
RUN git clone $REPO

# Joinmarket root
WORKDIR /joinmarket-clientserver
#RUN mkdir deps
#RUN mkdir -p lib/pkgconfig
#RUN mkdir include
RUN git checkout $VERSION

# Build dependencies
# Dep - libsecp256k1
#WORKDIR /
#RUN wget "$LIBSECP256K1"
#RUN tar xvfz 0d9540b13ffcd7cd44cc361b8744b93d88aa76ba.tar.gz
#WORKDIR /secp256k1-0d9540b13ffcd7cd44cc361b8744b93d88aa76ba
#RUN ./autogen.sh
#RUN ./configure \
#    --enable-module-recovery \
#    --disable-jni \
#    --prefix=/joinmarket-clientserver \
#    --enable-experimental \
#    --enable-module-ecdh \
#    --enable-benchmark=no
#RUN make
#RUN make install
# Dep - libsodium
#WORKDIR /
#RUN curl -L  "$LIBSODIUM" -o libsodium-1.0.18.tar.gz
#RUN tar xvfz libsodium-1.0.18.tar.gz
#WORKDIR /libsodium-1.0.18
#RUN ./autogen.sh
#RUN ./configure \
#    --enable-minimal \
#    --enable-shared \
#    --prefix=/joinmarket-clientserver
#RUN make
#RUN make install


#WORKDIR /joinmarket-clientserver
RUN pip install -r "requirements/base.txt"

# Notes:
# jm_root is '$PWD/jmvenv'
# jm_deps is '$PWD/deps
# PKG_CONFIG is '$PWD/lib/pkgconfig' or what PKG_CONFIG is set to
# LD_LIBRARY_PATH  is '$PWD/lib' or what LD_LIBRARY_PATH is set to
# C_INCLUDE_PATH  is '$PWD/include' or what C_INCLUDE_PATH is set to


