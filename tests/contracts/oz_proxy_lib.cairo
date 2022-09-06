// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.1.0 (upgrades/library.cairo)

%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

//
// Events
//

@event
func Upgraded(implementation: felt) {
}

//
// Storage variables
//

@storage_var
func Proxy_implementation_address() -> (implementation_address: felt) {
}

@storage_var
func Proxy_admin() -> (proxy_admin: felt) {
}

@storage_var
func Proxy_initialized() -> (initialized: felt) {
}

//
// Initializer
//

func Proxy_initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    proxy_admin: felt
) {
    let (initialized) = Proxy_initialized.read();
    with_attr error_message("Proxy: contract already initialized") {
        assert initialized = FALSE;
    }

    Proxy_initialized.write(TRUE);
    Proxy_admin.write(proxy_admin);
    return ();
}

//
// Upgrades
//

func Proxy_set_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    Proxy_implementation_address.write(new_implementation);
    Upgraded.emit(new_implementation);
    return ();
}

//
// Guards
//

func Proxy_only_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    let (admin) = Proxy_admin.read();
    with_attr error_message("Proxy: caller is not admin") {
        assert admin = caller;
    }
    return ();
}

//
// Getters
//

func Proxy_get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    admin: felt
) {
    let (admin) = Proxy_admin.read();
    return (admin,);
}

func Proxy_get_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (implementation: felt) {
    let (implementation) = Proxy_implementation_address.read();
    return (implementation,);
}

//
// Setters
//

func Proxy_set_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_admin: felt
) {
    Proxy_admin.write(new_admin);
    return ();
}
