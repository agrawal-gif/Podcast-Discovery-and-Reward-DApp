// Podcast Discovery and Reward DApp - Smart Contract and Project Structure

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PodcastDiscovery {

    struct Podcast {
        uint id;
        string title;
        string description;
        address creator;
        uint tipAmount;
    }

    struct User {
        address wallet;
        uint totalRewards;
    }

    uint public podcastCount;
    mapping(uint => Podcast) public podcasts;
    mapping(address => User) public users;

    event PodcastCreated(
        uint id,
        string title,
        string description,
        address creator
    );

    event PodcastTipped(
        uint id,
        uint tipAmount,
        address tipper
    );

    function createPodcast(string memory _title, string memory _description) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");

        podcastCount++;

        podcasts[podcastCount] = Podcast(
            podcastCount,
            _title,
            _description,
            msg.sender,
            0
        );

        emit PodcastCreated(podcastCount, _title, _description, msg.sender);
    }

    function tipPodcast(uint _id) public payable {
        require(_id > 0 && _id <= podcastCount, "Invalid podcast ID");
        require(msg.value > 0, "Tip must be greater than 0");

        Podcast memory _podcast = podcasts[_id];
        _podcast.tipAmount += msg.value;
        podcasts[_id] = _podcast;

        payable(_podcast.creator).transfer(msg.value);

        emit PodcastTipped(_id, msg.value, msg.sender);
    }

    function getPodcasts() public view returns (Podcast[] memory) {
        Podcast[] memory allPodcasts = new Podcast[](podcastCount);

        for (uint i = 1; i <= podcastCount; i++) {
            allPodcasts[i - 1] = podcasts[i];
        }

        return allPodcasts;
    }
}
