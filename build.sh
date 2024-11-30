make clean
# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium2/opt bin/crypto_sign_dilithium2_opt_test.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium2_opt_test.bin 0x8000000

# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium2/opt bin/crypto_sign_dilithium2_opt_stack.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium2_opt_stack.bin 0x8000000

# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium2/opt bin/crypto_sign_dilithium2_opt_speed.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium2_opt_speed.bin 0x8000000


# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium3/opt bin/crypto_sign_dilithium3_opt_test.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium3_opt_test.bin 0x8000000


# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium3/opt bin/crypto_sign_dilithium3_opt_stack.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium3_opt_stack.bin 0x8000000

# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium3/opt bin/crypto_sign_dilithium3_opt_speed.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium3_opt_speed.bin 0x8000000



make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium5/opt bin/crypto_sign_dilithium5_opt_speed.bin
sudo st-flash --reset write bin/crypto_sign_dilithium5_opt_speed.bin 0x8000000


# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium5/opt bin/crypto_sign_dilithium5_opt_test.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium5_opt_test.bin 0x8000000


# make -j 12 IMPLEMENTATION_PATH=crypto_sign/dilithium5/opt bin/crypto_sign_dilithium5_opt_stack.bin
# sudo st-flash --reset write bin/crypto_sign_dilithium5_opt_stack.bin 0x8000000
