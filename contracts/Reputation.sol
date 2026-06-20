// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {Marketplace} from "./Marketplace.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
/// @title Reputation — Slice 4 (Reputation / Ratings)  [STUDENT TEMPLATE]
/// @notice Implement every TODO(member4). Spec: test/Reputation.t.sol.
contract Reputation is ReentrancyGuard {
    Marketplace public immutable market;
    mapping(address => uint256) private ratingTotal;
    mapping(address => uint256) private ratingCount;
    mapping(uint256 => bool) public listingRated;
    event RatingSubmitted(address indexed rater, address indexed rated, uint8 rating, uint256 indexed listingId);
    error NotSold(); error NotBuyer(); error BadRating(); error AlreadyRated();
    constructor(address marketplace) { market = Marketplace(marketplace); }
    function rateUser(uint256 listingId, uint8 rating) external nonReentrant {
        // TODO(member4): read market.getListing(listingId); require Sold + caller==buyer + 1<=rating<=5 + !listingRated;
        //               record (listingRated, ratingTotal[seller]+=rating, ratingCount[seller]++); emit RatingSubmitted.
        revert("TODO(member4): implement rateUser");
    }
    function getAverageRating(address user) external view returns (uint256 total, uint256 count) {
        return (ratingTotal[user], ratingCount[user]);
    }
}
