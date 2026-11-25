# Misprint

A rhythm racer in two inks. Steer through the gaps, hop the pink teeth, hit the yellow rings on the beat.

**Play:** https://manow17.github.io/misprint/

## How to drive

| | |
|---|---|
| mouse, or `A` `D` / `←` `→` | steer |
| `space` `W` `↑`, or right-click | hop |
| `J` `K` `Z` `X`, or left-click | hit a ring as you pass through it; on a yellow trail, hold and follow it |
| `esc` | bail |

Blue walls tear off a sheet. Pink arrow pads throw you over a whole field of teeth.

## Tracks

Ten named tracks across five tiers (easy, normal, hard, brutal, misprint), or type any number to press a custom one. A track's song and road come entirely from its number, so the same number always plays the same.

## Racing friends

Host a race, send the four-letter code (or the invite link), and everyone races at once on two roads side by side. Both roads get the same song with mirrored layouts, and each road's scores are added up at the end.

Connections are peer to peer over WebRTC. The public [PeerJS](https://peerjs.com/) server is only used to introduce players; race data goes directly between browsers. Very strict networks (some offices and campuses) can block direct connections.

## Run it locally

It's a single `index.html` with no build step. Serve the folder with anything static, for example:

```
python -m http.server 8417
```

All music and sound is synthesized in the browser with the Web Audio API.
