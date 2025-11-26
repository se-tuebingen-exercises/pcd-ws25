# Exercise 04: Asynchronous Communication

## Benchmark Counting Words and Image Pipeline

Compare the running time of the same programs from Exercise 03 between Java and
JavaScript. Instead of Java futures use JavaScript promises and instead of Java
blocking queues use async iterators. What do you expect?

Use files `word_count.js` and `image_pipeline.js` as starting points and feel
free to optimize all programs while continually benchmarking.

## Scraping Hacker News

Fetch the top 30 stories from Hacker News and then for of them up to 1 comment
and then for each of them up to 1 reply.

The Hacker News API provides the following endpoints:
```
https://hacker-news.firebaseio.com/v0/topstories.json?limitToFirst=30&orderBy="$key"
```
This returns an array of story IDs.

To fetch details for a specific item (story, comment, or reply), use:
```
https://hacker-news.firebaseio.com/v0/item/{id}.json
```
This returns JSON with a kids field containing an array of child item IDs. For
stories, kids contains comment IDs. For comments, kids contains reply IDs.

Use file `hackernews_scraper.js` as a starting point.

