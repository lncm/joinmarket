#!/usr/bin/env python3

'''
Prototype file:
https://github.com/JoinMarket-Org/joinmarket-clientserver/blob/master/jmclient/jmclient/wallet_utils.py

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
'''

import sys
import os

from jmclient import load_program_config, add_base_options, SegwitLegacyWallet, create_wallet, jm_single
from jmbase.support import get_log, jmprint

def main():
    words = "seed-goes-here"
    password = "password-goes-here".encode("utf-8")
    words.strip()
    entropy = SegwitLegacyWallet.entropy_from_mnemonic(words)
    load_program_config(config_path="/data/.joinmarket")
    wallet_root_path = os.path.join(jm_single().datadir, "wallets")
    wallet_name = os.path.join(wallet_root_path, "wallet2.jmdat")
    wallet = create_wallet(wallet_name, password, 4, SegwitLegacyWallet,
                           entropy=entropy,
                           entropy_extension=None)
    jmprint("recovery_seed:{}"
         .format(wallet.get_mnemonic_words()[0]), "important")
    wallet.close()
if __name__ == "__main__":
    main()
