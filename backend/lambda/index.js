const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, GetCommand, PutCommand, UpdateCommand, QueryCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

const USER_PROFILES_TABLE = process.env.USER_PROFILES_TABLE;
const GAME_SCORES_TABLE = process.env.GAME_SCORES_TABLE;

exports.handler = async (event) => {
  console.log('Event:', JSON.stringify(event));

  const { routeKey, requestContext, body } = event;
  const userId = requestContext.authorizer?.jwt?.claims?.sub;

  try {
    switch (routeKey) {
      case 'GET /profile':
        return await getProfile(userId);
      
      case 'PUT /profile':
        return await updateProfile(userId, JSON.parse(body));
      
      case 'POST /scores':
        return await saveScore(userId, JSON.parse(body));
      
      case 'GET /scores/{gameId}':
        return await getUserScores(userId, event.pathParameters.gameId);
      
      case 'GET /leaderboard/{gameId}':
        return await getLeaderboard(event.pathParameters.gameId);
      
      default:
        return response(404, { error: 'Not found' });
    }
  } catch (error) {
    console.error('Error:', error);
    return response(500, { error: error.message });
  }
};

async function getProfile(userId) {
  const result = await ddb.send(new GetCommand({
    TableName: USER_PROFILES_TABLE,
    Key: { userId }
  }));

  if (!result.Item) {
    const newProfile = {
      userId,
      username: 'Player',
      createdAt: new Date().toISOString(),
      gamesPlayed: 0
    };
    await ddb.send(new PutCommand({
      TableName: USER_PROFILES_TABLE,
      Item: newProfile
    }));
    return response(200, newProfile);
  }

  return response(200, result.Item);
}

async function updateProfile(userId, data) {
  const { username } = data;
  
  await ddb.send(new UpdateCommand({
    TableName: USER_PROFILES_TABLE,
    Key: { userId },
    UpdateExpression: 'SET username = :username, updatedAt = :updatedAt',
    ExpressionAttributeValues: {
      ':username': username,
      ':updatedAt': new Date().toISOString()
    }
  }));

  return response(200, { message: 'Profile updated' });
}

async function saveScore(userId, data) {
  const { gameId, score, metadata } = data;
  
  const item = {
    userId,
    gameId,
    score,
    metadata: metadata || {},
    timestamp: new Date().toISOString()
  };

  await ddb.send(new PutCommand({
    TableName: GAME_SCORES_TABLE,
    Item: item
  }));

  await ddb.send(new UpdateCommand({
    TableName: USER_PROFILES_TABLE,
    Key: { userId },
    UpdateExpression: 'ADD gamesPlayed :inc',
    ExpressionAttributeValues: { ':inc': 1 }
  }));

  return response(200, { message: 'Score saved', data: item });
}

async function getUserScores(userId, gameId) {
  const result = await ddb.send(new QueryCommand({
    TableName: GAME_SCORES_TABLE,
    KeyConditionExpression: 'userId = :userId AND gameId = :gameId',
    ExpressionAttributeValues: {
      ':userId': userId,
      ':gameId': gameId
    },
    ScanIndexForward: false,
    Limit: 10
  }));

  return response(200, result.Items || []);
}

async function getLeaderboard(gameId) {
  const result = await ddb.send(new QueryCommand({
    TableName: GAME_SCORES_TABLE,
    IndexName: 'GameScoreIndex',
    KeyConditionExpression: 'gameId = :gameId',
    ExpressionAttributeValues: { ':gameId': gameId },
    ScanIndexForward: false,
    Limit: 10
  }));

  return response(200, result.Items || []);
}

function response(statusCode, body) {
  return {
    statusCode,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    },
    body: JSON.stringify(body)
  };
}
