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
        #echo $RECOVERYSEED
        SEEDONLY=`echo "$RECOVERYSEED" | cut -d ':' -f2`
        #echo $SEEDONLY
        echo $SEEDONLY > $JMSEEDFILE
    else
        echo "Error generating wallet"
        rm $JMWALLETDIR/$JMWALLET
        exit 1
    fi
    echo "Wallet created"
    exit 0
else
    echo "Wallet already created"
fi
# TODO: Display wallet
