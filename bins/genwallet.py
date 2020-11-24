#!/usr/bin/env python3

"""
Prototype: demonstrate you can automatically generate a wallet (using the base API
https://github.com/JoinMarket-Org/joinmarket-clientserver/blob/master/jmclient/jmclient/wallet_utils.py)

Credit goes to @nix-bitcoin (https://github.com/fort-nix/nix-bitcoin) for the initial POC

output is seed as a JSON string
"""

import sys
import os
from optparse import OptionParser
from jmclient import load_program_config, add_base_options, SegwitLegacyWallet, create_wallet, jm_single
from jmbase.support import get_log, jmprint

log = get_log()

def main():
    parser = OptionParser(
    usage='usage: %prog [options] wallet_file_name password',
    description='Create a wallet with the given wallet name and password.')
    add_base_options(parser)
    (options, args) = parser.parse_args()
    if options.wallet_password_stdin:
        stdin = sys.stdin.read()
        password = stdin.encode("utf-8")
    else:
        assert len(args) > 1, "must provide password via stdin (see --help), or as second argument."
        password = args[1].encode("utf-8")
    load_program_config(config_path=options.datadir)
    wallet_root_path = os.path.join(jm_single().datadir, "wallets")
    wallet_name = os.path.join(wallet_root_path, args[0])
    wallet = create_wallet(wallet_name, password, 4, SegwitLegacyWallet)
    # Open file for writing
    seedfile = open(os.path.join(jm_single().datadir, "jm-wallet-seed"), "w")
    seedfile.write(wallet.get_mnemonic_words()[0])
    seedfile.close()

    jmprint("recovery_seed:{}"
         .format(wallet.get_mnemonic_words()[0]), "important")
    wallet.close()

if __name__ == "__main__":
    main()
