module MyModule::DigitalTicketing {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    struct Ticket has store, key {
        event_name: vector<u8>,  // Name of the event
        price: u64,              // Price of the ticket
        owner: address,          // Owner of the ticket
    }

    /// Function for event organizers to issue a ticket as an NFT.
    public fun issue_ticket(organizer: &signer, event_name: vector<u8>, price: u64) {
        let ticket = Ticket {
            event_name,
            price,
            owner: signer::address_of(organizer),
        };
        move_to(organizer, ticket);
    }

    /// Function to transfer a ticket (resell) to a new owner.
    public fun transfer_ticket(signer: &signer, ticket_owner: address, new_owner: address) acquires Ticket {
        let ticket = borrow_global_mut<Ticket>(ticket_owner);
        assert!(signer::address_of(signer) == ticket_owner, 1);  // Ensure the signer is the current owner

        // Transfer the ownership of the ticket to the new owner
        ticket.owner = new_owner;
    }
}
