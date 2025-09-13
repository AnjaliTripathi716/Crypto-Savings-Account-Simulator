module MyModule::Voting {
    use aptos_framework::signer;
    use std::vector;
    
    /// Struct representing a voting poll
    struct Poll has store, key {
        yes_votes: u64,      // Number of yes votes
        no_votes: u64,       // Number of no votes
        voters: vector<address>, // Track who has voted to prevent double voting
    }
    
    /// Function to create a new voting poll
    public fun create_poll(creator: &signer) {
        let poll = Poll {
            yes_votes: 0,
            no_votes: 0,
            voters: vector::empty<address>(),
        };
        move_to(creator, poll);
    }
    
    /// Function to cast a vote (true for yes, false for no)
    public fun cast_vote(voter: &signer, poll_owner: address, vote: bool) acquires Poll {
        let voter_address = signer::address_of(voter);
        let poll = borrow_global_mut<Poll>(poll_owner);
        
        // Check if voter has already voted
        assert!(!vector::contains(&poll.voters, &voter_address), 1);
        
        // Record the vote
        if (vote) {
            poll.yes_votes = poll.yes_votes + 1;
        } else {
            poll.no_votes = poll.no_votes + 1;
        };
        
        // Add voter to the list to prevent double voting
        vector::push_back(&mut poll.voters, voter_address);
    }
}