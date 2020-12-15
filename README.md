# README

### Book Searcher
This project is an API that consumes the Google Books API to search books by title and author.

To search, use the following curl request:

```
curl -X POST \
-H "Content-type: application/json" \
-H "Accept: application/json" \
-d '{"attributes":{"title":"How to Survive a Garden Gnome Attack","author":"Sambuchino"}}' \
"https://young-beyond-76745.herokuapp.com/searches/"
```

You can sort the results by most relevant or newest:
`-d '{"attributes":{...},"sort":{"newest": true}}'`

You can filter the results by ebook availiability:
`-d '{"attributes":{...},"filter":{"ebook": true}}'`
