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

## Build your own levels

**Build a level** opens the workshop. Pick a song number and a speed, then click squares on the road to place rings, walls, teeth and pads. Press space to hear the music while you place things. **Test drive** plays it, and once you've driven it to the finish you can **Publish** it so anyone can play it from **Community levels**. Drafts save in your browser automatically.

## Community levels

The live site is already connected to a Supabase database, so publishing and browsing work out of the box.

### Connecting your own copy (free, about 5 minutes)

If you fork this, point it at your own free [Supabase](https://supabase.com) project:

1. Sign up at supabase.com and click **New project**. Any name and region works. Save the database password somewhere, though the game never needs it.
2. When the project is ready, open **SQL Editor** in the left sidebar, start a new query, paste everything from [`supabase/levels.sql`](supabase/levels.sql), and press **Run**.
3. Click **Connect** at the top of the project page (or go to **Project Settings → API Keys**). Copy the **Project URL** and the **anon** or **publishable** key. Never use the `service_role` or **secret** key.
4. Put both into `index.html`, near the line that says `SUPABASE_URL`:
   ```js
   const SUPABASE_URL = 'https://your-project.supabase.co';
   const SUPABASE_KEY = 'your-anon-or-publishable-key';
   ```
5. Commit and push. Done.

The anon/publishable key is meant to sit in a public website. The rules in `levels.sql` only let visitors read levels and add new ones; nobody can edit or delete through the site. You can remove spam from the Supabase **Table Editor**. Free projects go to sleep after a week with no visitors; waking one up is a single click in the Supabase dashboard.

## Run it locally

It's a single `index.html` with no build step. Serve the folder with anything static, for example:

```
python -m http.server 8417
```

All music and sound is synthesized in the browser with the Web Audio API.
