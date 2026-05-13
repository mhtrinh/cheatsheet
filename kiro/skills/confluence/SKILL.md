---
name: confluence
description: Search and answer questions using the team's Confluence wiki. Use when the user says "search confluence" or invokes /confluence.
---

Search the team Confluence site and answer the user's question using page content.
The user's message (the text they typed after `/confluence` or alongside "search confluence") IS the question. Use it directly.

Site: digitalinnovationnetwork.atlassian.net
Cloud ID: e8f7f5dc-ffbf-4629-979b-8c31203620f6

## Step 1 — Search

Use `searchConfluenceUsingCql` with a CQL query derived from the user's question.
- Use `text ~ "term"` for content search, `title ~ "term"` for title search.
- Combine terms with OR/AND as appropriate.
- Set limit to 5.

## Step 2 — Evaluate excerpts

Review the titles and excerpts from the search results.
- Identify the 1-2 pages most likely to answer the user's question.
- If no result clearly matches, go to Step 4 (fallback).

## Step 3 — Read and answer

Use `getConfluencePage` (with contentFormat "markdown") to read the full content of the 1-2 most relevant pages.
- Synthesize an answer to the user's question from the page content.
- Cite the page title and link for each source used.
- If the pages don't fully answer the question, say what's missing.

## Step 4 — Fallback (no clear match)

If no search result clearly answers the question:
- List the top results with title, excerpt, and link.
- Ask the user which page to read, or whether to refine the search.
