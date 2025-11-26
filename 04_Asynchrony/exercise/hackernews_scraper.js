async function fetchTopStories() {
    const url = `https://hacker-news.firebaseio.com/v0/topstories.json?limitToFirst=30&orderBy="$key"`;
}

async function fetchItem(id) {
    const url = `https://hacker-news.firebaseio.com/v0/item/${id}.json`;
}

