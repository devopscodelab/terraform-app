
const AWS = require('aws-sdk');
const s3 = new AWS.S3();

exports.handler = async (event) => {
  try {
    const data = await s3.listBuckets().promise();
    return {
      statusCode: 200,
      body: JSON.stringify({
        buckets: data.Buckets.map(bucket => bucket.Name)
      })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
