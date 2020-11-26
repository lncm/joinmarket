#!/usr/bin/env python3

"""
Prototype: demonstrate you can automatically generate a wallet (using the base API
https://github.com/JoinMarket-Org/joinmarket-clientserver/blob/master/jmclient/jmclient/wallet_utils.py)

Credit goes to @nix-bitcoin (https://github.com/fort-nix/nix-bitcoin) for the initial file

output is seed as a JSON string

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

"""

import sys
import os
from optparse import OptionParser
from jmclient import load_program_config, add_base_options, SegwitWallet, SegwitLegacyWallet, create_wallet, jm_single
from jmbase.support import get_log, jmprint

log = get_log()

def main():
    parser = OptionParser(
    usage='usage: %prog [options] wallet_file_name password',
    description='Create a wallet with the given wallet name and password.')
    (options, args) = parser.parse_args()

    # Load up defaults
    load_program_config(config_path='/data/.joinmarket')
    wallet_root_path = os.path.join(jm_single().datadir, "wallets")
    # get wallet from first argument
    wallet_name = os.path.join(wallet_root_path, args[0])
    wallet = create_wallet(wallet_name, args[1].encode("utf-8"), 4, SegwitWallet)
    # Open file for writing
    seedfile = open(os.path.join(jm_single().datadir, "jm-wallet-seed"), "w")
    seedfile.write(wallet.get_mnemonic_words()[0])
    seedfile.write("\n")
    seedfile.close()

    jmprint("recovery_seed:{}"
         .format(wallet.get_mnemonic_words()[0]), "important")
    wallet.close()

if __name__ == "__main__":
    main()
