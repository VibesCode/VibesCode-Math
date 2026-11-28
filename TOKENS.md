# What each result cost to find

Figures come from the usage records of the Claude sessions that worked on each result, read on 2026-11-27 at about 08:15 UTC. They are measured, not estimated.

- **Tokens processed** counts every token the models read or wrote. Most of it is the working context, which is read again at each step (and mostly served from cache). **Output tokens** are the tokens the models wrote, reasoning included.
- Each figure covers the whole working session or sessions for that result. That includes dead ends, failed attempts, literature and novelty checks, and the Lean and program work.
- Each figure leaves out the shared work below, which served all results together. It also leaves out runs on a separate local machine, whose usage was not recorded here. Computer time spent on searches and solvers is not tokens and is not counted.

## Per result

| Result | Total processed | Output | By model: processed (output) | Note |
| --- | --- | --- | --- | --- |
| Tangent sum, explicit n₀ = 5 | 45.6M | 490k | Opus 5.5 39.1M (287k out); Sonnet 5.5 5.3M (90k out); Haiku 5.5 0.7M (87k out); Fable 5.2 0.6M (25k out) | two working sessions |
| Erdős 707 (Mueller's sets) | 20.8M | 251k | Opus 5.5 18.3M (170k out); Sonnet 5.5 2.0M (25k out); Haiku 5.5 0.5M (55k out) |  |
| Huber's Sidon problem, s(16), s(17), s(18) | 19.4M | 85k | Opus 5.5 17.8M (57k out); Sonnet 5.5 1.6M (24k out); Haiku 5.5 0.1M (4k out) | one session, all three values; read 2026-11-27 at 18:13 UTC |
| Crystal uniqueness (partial) | 51.9M | 538k | Opus 5.5 43.4M (343k out); Sonnet 5.5 7.8M (154k out); Haiku 5.5 0.8M (42k out) | two working sessions |
| OEIS A135508 | 11.0M | 80k | Opus 5.5 9.5M (61k out); Sonnet 5.5 1.4M (9k out); Haiku 5.5 0.1M (11k out) |  |
| OEIS A245212 | 8.3M | 67k | Opus 5.5 7.6M (56k out); Sonnet 5.5 0.7M (6k out); Haiku 5.5 0.1M (5k out) |  |
| OEIS A120121–A120123 and A058627 | 14.5M | 164k | Opus 5.5 11.9M (87k out); Sonnet 5.5 2.6M (73k out); Haiku 5.5 <0.1M (4k out) | one session did both; not separable |
| OEIS A379397–A379400 | 5.0M | 56k | Opus 5.5 3.4M (25k out); Sonnet 5.5 1.4M (17k out); Haiku 5.5 0.2M (13k out) |  |
| OEIS A066494 / A066516 | 8.0M | 114k | Opus 5.5 5.3M (48k out); Sonnet 5.5 2.5M (44k out); Haiku 5.5 0.3M (22k out) |  |
| Sorting networks, Van Voorhis's recurrence | 13.2M | 141k | Opus 5.5 10.9M (86k out); Sonnet 5.5 1.8M (21k out); Haiku 5.5 0.4M (34k out) |  |
| Covering arrays CA(179; 3, 39, 4) and CA(216; 3, 11, 5) | 26.9M | 155k | Opus 5.5 25.3M (111k out); Sonnet 5.5 0.9M (14k out); Haiku 5.5 0.7M (30k out) | one session found both; not separable; read 2026-11-27 at 13:44 UTC |
| OEIS A226472, A073614, A392801, A262783 and A224241 | 73.8M | 569k | Opus 5.5 30.3M (119k out); Sonnet 5.5 41.5M (279k out); Haiku 5.5 2.0M (171k out) | one session found all four results, and also worked on other problems with no result here; whole session, not separable; read 2026-11-27 at 22:31 UTC |
| Sun's p + 2^x + k·2^y, k = 47 | 24.7M | 122k | Opus 5.5 21.2M (92k out); Sonnet 5.5 3.3M (24k out); Haiku 5.5 0.2M (5k out) | whole working session, which also tested other OEIS claims with no result here; read 2026-11-27 at 22:56 UTC |
| OEIS A263546, A263076 and A153022 | 30.5M | 94k | Opus 5.5 30.5M (94k out) | one session found all three, and also scanned other entries with no result here; whole session, not separable; read 2026-11-28 at 08:59 UTC |
| Erdős 261(ii), n ≤ 10^6 | 17.5M | 95k | Opus 5.5 15.3M (69k out); Sonnet 5.5 2.1M (21k out); Haiku 5.5 0.1M (5k out) | whole working session, which may include other work; read 2026-11-27 at 19:29 UTC |
| Erdős 686 and 677 search bounds | 13.0M | 87k | Opus 5.5 10.9M (70k out); Sonnet 5.5 2.1M (16k out); Haiku 5.5 <0.1M (1k out) | whole working session, which may include other work; read 2026-11-28 at 19:21 UTC |

## Shared work, not split between results

| Shared work | Total processed | Output | By model: processed (output) |
| --- | --- | --- | --- |
| Independent rechecking of every result | 90.0M | 400k | Opus 5.5 85.0M (272k out); Sonnet 5.5 4.4M (60k out); Haiku 5.5 0.6M (67k out) |
| Searching for and screening problems (three sessions) | 145.7M | 1,598k | Opus 5.5 66.9M (251k out); Sonnet 5.5 68.0M (575k out); Haiku 5.5 10.7M (772k out) |
| Preparing and checking this repository | 84.0M | 254k | Opus 5.5 82.7M (232k out); Sonnet 5.5 1.3M (8k out); Haiku 5.5 0.1M (14k out) |

Coordinating the work across sessions also used tokens (Claude Mythos 5.2). Its usage record was not kept in full, so it is **not recorded** here.

From now on, each new result gets its figure when it is added.
