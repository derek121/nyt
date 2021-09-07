# Workpath Project

Routes defined in `lib/comments_web/router.ex`
Implementation in `lib/comments_web/controllers/comments_controller.ex`

```
# Get UUIDs for the nyregion section
$ curl http://localhost:4000/article_uuids/nyregion
debf1af0-40ac-5457-ba31-20aa40759a56
74c7a059-b044-582c-b9df-e68fb486acb2
ac950d9b-ebe2-58e2-af22-c6f00de9fbb5
<...>

# Get comments for the first one (none yet)
$ curl -XGET http://localhost:4000/articles/debf1af0-40ac-5457-ba31-20aa40759a56/comments | jq
[]

# Add three comments to the first article
$ BODY='{"author": "Derek Brown", "body": "Cool story"}'
$ curl -XPOST -H 'Content-Type: application/json' --data-binary "$BODY"  http://localhost:4000/articles/debf1af0-40ac-5457-ba31-20aa40759a56/comments
{"article_id":"debf1af0-40ac-5457-ba31-20aa40759a56","author":"Derek Brown","body":"Cool story","id":"e526fb56-0fea-11ec-8f18-0800277fa343","posted_at":"2021-09-07T14:50:08.294387Z"}

$ curl -XPOST -H 'Content-Type: application/json' --data-binary "$BODY"  http://localhost:4000/articles/debf1af0-40ac-5457-ba31-20aa40759a56/comments
{"article_id":"debf1af0-40ac-5457-ba31-20aa40759a56","author":"Derek Brown","body":"Cool story","id":"e6e22006-0fea-11ec-8cdc-0800277fa343","posted_at":"2021-09-07T14:50:11.198571Z"}

$ curl -XPOST -H 'Content-Type: application/json' --data-binary "$BODY"  http://localhost:4000/articles/debf1af0-40ac-5457-ba31-20aa40759a56/comments
{"article_id":"debf1af0-40ac-5457-ba31-20aa40759a56","author":"Derek Brown","body":"Cool story","id":"e8ac0352-0fea-11ec-b062-0800277fa343","posted_at":"2021-09-07T14:50

# See the three comments added
$ curl -XGET http://localhost:4000/articles/debf1af0-40ac-5457-ba31-20aa40759a56/comments | jq
[
{
"article_id": "debf1af0-40ac-5457-ba31-20aa40759a56",
"author": "Derek Brown",
"body": "Cool story",
"id": "e8ac0352-0fea-11ec-b062-0800277fa343",
"posted_at": "2021-09-07T14:50:14.199388Z"
},
{
"article_id": "debf1af0-40ac-5457-ba31-20aa40759a56",
"author": "Derek Brown",
"body": "Cool story",
"id": "e6e22006-0fea-11ec-8cdc-0800277fa343",
"posted_at": "2021-09-07T14:50:11.198571Z"
},
{
"article_id": "debf1af0-40ac-5457-ba31-20aa40759a56",
"author": "Derek Brown",
"body": "Cool story",
"id": "e526fb56-0fea-11ec-8f18-0800277fa343",
"posted_at": "2021-09-07T14:50:08.294387Z"
}
]

# Get article summaries. See the 3 comments accounted for for the first article
$ curl http://localhost:4000/articles?section=nyregion | jq
[
{
"byline": "By Corey Kilgannon",
"id": "debf1af0-40ac-5457-ba31-20aa40759a56",
"published_date": "2021-09-06T16:26:10-04:00",
"title": "â€˜Reopening Old Woundsâ€™: When 9/11 Remains Are Identified, 20 Years Later",
"comments_count": 3,
"comments_path": "/articles/debf1af0-40ac-5457-ba31-20aa40759a56/comments"
},
{
"byline": "By Colin Moynihan",
"id": "74c7a059-b044-582c-b9df-e68fb486acb2",
"published_date": "2021-09-07T05:00:08-04:00",
"title": "Nxivmâ€™s Second-in-Command Helped Build a Culture of Abuse, Survivors Say",
"comments_count": 0,
"comments_path": "/articles/74c7a059-b044-582c-b9df-e68fb486acb2/comments"
},
{
"byline": "By Julia Jacobs, Annie Correal, Matthew Haag and Jeremy Egner",
"id": "ac950d9b-ebe2-58e2-af22-c6f00de9fbb5",
"published_date": "2021-09-06T17:07:08-04:00",
"title": "Michael K. Williams, Omar From â€˜The Wire,â€™ Is Dead at 54",
"comments_count": 0,
"comments_path": "/articles/ac950d9b-ebe2-58e2-af22-c6f00de9fbb5/comments"
},
<...>
]
```
