## Issues solved and how to test them:


- Issue #147 - Make more explicit when a player has pressed the “Return to Lobby” button
- Test: Load up a multiplayer game, and have one player exit mid-match. If text pops up saying "Opponent has left the lobby," this test was successful
- Issue #277 - You can sell opponent jokers in the game over screen 
- Test: Load up a multiplayer game, set to Standard. Set lives to 1. Play until each player gets a Joker, and then get a gameover. If you click on an opponent's joker and the "sell" graphic is greyed out, this test was successful.
- Issue #172 - Possible softlock / issue with max lives or some other setting
- Test: Load into a multiplayer match, Start the game and skip the blinds to the wanted PvP Blind, Click Ready. If one player is inside pvp and the another isn't the game will now automatically unstuck the player, If any player is automatically unstucked then this test was successful.
- Issue #352 - Bug: changing multiplayer settings crash
- Test: Try to change multiplayer settings mid-game in the Mods menu. If a message pops up that says "Multiplayer settings cannot be changed during a match." then this test was successful.
- Issue #320 - Error: Failed to parse message
- Test: (issue tested automatically in github actions)
- Issue #245 - Different Tags with same seed
- Test: Play through several blinds/antes and confirm the same tag appears in the same blind slot for both players every time.
- Issue #370 - Creating lobby has no host
- Test: Create a lobby and invite someone. If the players have (Host) and (Guest) next to them, this test was successful.


# Balatro Multiplayer Mod

![ModIcon](https://github.com/Balatro-Multiplayer/BalatroMultiplayer/blob/2cd9015963c1118e0b849f11e7c335f97b74f36c/assets/2x/modicon.png)

A multiplayer mod for Balatro, allowing players to compete with each other.

## 📥 Installation

Detailed installation instructions are available on our website:
[https://balatromp.com/docs/getting-started/installation](https://balatromp.com/docs/getting-started/installation)

*Requires [Steamodded](https://github.com/Steamodded/smods) (>=1.0.0~BETA-1221a) and [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector) (>=0.8)

Quick installation steps:

1. Download the latest release from the [Releases page](https://github.com/Balatro-Multiplayer/BalatroMultiplayer/releases)
2. Extract the files into a new folder in your Balatro mods directory
3. Run the game

## 🎲 Usage

1. Launch Balatro with the multiplayer mod enabled
2. From the main menu, select "Play", then "Create Lobby"
3. Select a ruleset/gamemode
4. Press "View Code" and send the code to the person you want to play with
5. The other player will select "Play", then "Join Lobby" and enter the code
6. Press "Start" to start the game!
   
## 🤝 Contributing

We welcome contributions to the Balatro Multiplayer Mod! Here's how you can help:

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow the existing code style and conventions
- Write clear, descriptive commit messages
- Clearly explain the feature you have implemented in the pull request
- Ensure to properly test the feature and provide example seeds where the feature can clearly be seen working (if relevant)

Contributions that make content changes like modifying how the base game works, adding cards or blinds, or adding gamemodes will likely not be accepted. We are currently trying to maintain the competitive integrity of the mod and these types of changes need to be decided on by our team before being added.

### Looking to contribute but don't have a feature in mind?

Check the [issues](https://github.com/Balatro-Multiplayer/BalatroMultiplayer/issues), there are usually issues with the "Help Wanted" tag that are just looking for someone to work on them! I (Virtualized) try and be very clear about what the problem is and what the expected solution is in these issues so hopefully there is little confusion, but feel free to DM or ping `virtualized` on discord for clarification.

## 📜 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](https://github.com/V-rtualized/balatro-multiplayer/blob/main/LICENSE.md) file for details.

## 👏 Acknowledgements

- The LocalThunk for creating such an amazing game
- [All the contributors](https://github.com/Balatro-Multiplayer/BalatroMultiplayer/graphs/contributors) for their hard work
- Our Discord community for feedback, testing, and support

---

Join our [Discord server](https://discord.gg/balatromp) for support, to report bugs, or just to chat!
[Website](https://balatromp.com) | [GitHub](https://github.com/Balatro-Multiplayer/balatro-multiplayer)
