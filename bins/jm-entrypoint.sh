#!/bin/bash
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# inital variables
JMHOMEDIR=${HOME}/.joinmarket
JMWALLETDIR=${JMHOMEDIR}/wallets
JMWALLET=wallet.jmdat
# Define secrets
JMSEEDFILE=${JMHOMEDIR}/jm-wallet-seed
JMWALLETPASS=${JMHOMEDIR}/jm-wallet-password

# Other env variables (for config)
RPCUSER="${RPCUSER:-lncm}"          # Default username: lncm
RPCPASS="${RPCPASS:-lncm}"          # Default password: lncm
RPCHOST="${RPCHOST:-127.0.0.1}"     # Default hostname: 127.0.0.1
RPCPORT="${RPCPORT:-8332}"          # Default port: 8332
TORADDR="${TORADDR:-127.0.0.1}"     # Default address:  127.0.0.1
TORPORT="${TORPORT:-9050}"          # Default port for tor: 9050

# Genwallet.py location
# dep check
check_dependencies () {
    for cmd in "$@"; do
        if ! command -v $cmd >/dev/null 2>&1; then
            echo "This script requires \"${cmd}\" to be installed"
            exit 1
        fi
    done
}
check_dependencies pwgen

# Copy config from template if doesn't exist
if [ -f $HOME/joinmarket.cfg-dist ]; then
    # config doesnt exist
    if [ ! -f $JMHOMEDIR/joinmarket.cfg ]; then
        echo "Copying template config over"
        cp $HOME/joinmarket.cfg-dist $JMHOMEDIR/joinmarket.cfg
        echo "Configuring configuration info"
        sed -i "s/RPCUSER/${RPCUSER}/g; " $JMHOMEDIR/joinmarket.cfg
        sed -i "s/RPCPASS/${RPCPASS}/g; " $JMHOMEDIR/joinmarket.cfg
        sed -i "s/RPCHOST/${RPCHOST}/g; " $JMHOMEDIR/joinmarket.cfg
        sed -i "s/RPCPORT/${RPCPORT}/g; " $JMHOMEDIR/joinmarket.cfg
        sed -i "s/TORADDR/${TORADDR}/g; " $JMHOMEDIR/joinmarket.cfg
        sed -i "s/TORPORT/${TORPORT}/g; " $JMHOMEDIR/joinmarket.cfg
    fi
fi

# setup script
if [ ! -f $JMWALLETDIR/$JMWALLET ]; then
    if [ !  -f $JMWALLETPASS ]; then
        echo "Generating wallet password..."
        GENPASS=$(pwgen -s 21 -1 -v -c -0)
        echo $GENPASS > $JMWALLETPASS
    fi
    echo "Creating wallet..."
    WALLETOUT=`/usr/local/bin/genwallet.py $JMWALLET $GENPASS`
    RECOVERYSEED=$(echo "$WALLETOUT" | grep 'recovery_seed')
    if [[ ! -z $RECOVERYSEED ]]; then
        SEEDONLY=`echo "$RECOVERYSEED" | cut -d ':' -f2`
        echo $SEEDONLY > $JMSEEDFILE
    else
        echo "Error generating wallet"
        exit 1
    fi
    echo "Wallet created"
    exit 0
else
    echo "Wallet already created"
fi
# TODO: Display wallet
