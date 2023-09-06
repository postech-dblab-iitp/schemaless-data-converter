rm -rf generated-dataset/dynamic/person
mkdir generated-dataset/dynamic/person

python dataset-generator.py configurations/person/person_2.yaml json
mv generated-dataset/dynamic/person_0_0.json generated-dataset/dynamic/person/person_0_0_2.json

python dataset-generator.py configurations/person/person_5.yaml json
mv generated-dataset/dynamic/person_0_0.json generated-dataset/dynamic/person/person_0_0_5.json

python dataset-generator.py configurations/person/person_10.yaml json
mv generated-dataset/dynamic/person_0_0.json generated-dataset/dynamic/person/person_0_0_10.json

rm -rf generated-dataset/dynamic/post
mkdir generated-dataset/dynamic/post

python dataset-generator.py configurations/post/post_2.yaml json
mv generated-dataset/dynamic/post_0_0.json generated-dataset/dynamic/post/post_0_0_2.json

python dataset-generator.py configurations/post/post_5.yaml json
mv generated-dataset/dynamic/post_0_0.json generated-dataset/dynamic/post/post_0_0_5.json

python dataset-generator.py configurations/post/post_10.yaml json
mv generated-dataset/dynamic/post_0_0.json generated-dataset/dynamic/post/post_0_0_10.json

rm -rf generated-dataset/dynamic/comment
mkdir generated-dataset/dynamic/comment

python dataset-generator.py configurations/comment/comment_2.yaml json
mv generated-dataset/dynamic/comment_0_0.json generated-dataset/dynamic/comment/comment_0_0_2.json

python dataset-generator.py configurations/comment/comment_5.yaml json
mv generated-dataset/dynamic/comment_0_0.json generated-dataset/dynamic/comment/comment_0_0_5.json

python dataset-generator.py configurations/comment/comment_10.yaml json
mv generated-dataset/dynamic/comment_0_0.json generated-dataset/dynamic/comment/comment_0_0_10.json