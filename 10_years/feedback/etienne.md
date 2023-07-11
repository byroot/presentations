First contribution: show it for fun

Opportunity slide: « I my lead »

CJ/Gary Mardel: anonymize?

Counter cache: explanation first before patch using Active Record

Overconfidence? title but not in content. What does it refer to?

Searching for more clues: repro script explanation. Better than saying it’s hard in Shopify/shopify, explain why it’s useful (proprietary code, etc.)

logs highlight: alpha instead of box? more different colors

repro to test case: more high level description

mysql shell: maybe when you’re in debugging mode, pay extra attention to the logs

model callbacks: implemented as user feature

the case for monkey patch: when running released version, monkey patch is good. testing in prod, making sure it works/performs well

The problem: go through review. Maybe make it a bit more funny about the fact that maintainers are bad. Focus on relevant information.

takeaways: Intuitive, scientific method

Bug in your dependencies is a bug in your code (maybe « in your application »)

Takeaways 2: reproduction maybe more detailed.

Before bug#2 maybe life story (« Since then, I became rails core »)

Simple Rails limitation. Simple explanation but wrong. (Earlier assumption about counter caches not being broken)

hash: Give a better explanation (don’t mention Java) or don’t.

« Only manifests in 3.2 »

Needle in a haystack looking for bugs in a year worth of commits. (maybe worth mentioning running Rails main for that).

New information about payload. Reduce the potential surface.

Why const_get(:Status)?

allocate explanation could be better

explanation about why record use as hash keys (mention knowledge about codebase)

Why instance variables not the same order as in the initialize?

Marshal explanation: graph cycles fine because list of instructions

Don’t use parallel assignment for explanation about instance variables order.

Linking pieces of information to build hypotheses. I just happened to know (their talk would have helped anyway, I don’t think you needed to work with them to know that since they’ve done talks/articles explaining things)

console: feedback loop

Failing reproduction. First it works then it doesn’t anymore. IMO you need some rigor to be confident of yourself, and not invalidate a previous hypothesis. Inception debugging (bring another hypothesis to explain why repro would have worked and then not).

Fixing the bug: What is a bug? It’s not just removing the issue. The right place. There may be multiple places. (Don’t be defensive but refuse to rely on shaky grounds).

The defaults explanation may not be useful?

Ruby fix. Does that fix the issue? Don’t you still have the issue since it preserves the order, and dup was still causing the association to be first?

Takeaways: feedback loop working with vendor

Marshal use it with drb. More explanation

Semi-deterministic: negative for repro

Don’t rely on brittle things.
