import api from 'api/api';
import mockAxios from 'axios';

describe('API Object', () => {
  it('it has all API calls', async () => {
    expect(api.enterprises).toBeDefined();
    expect(api.users).toBeDefined();
    expect(api.userGroups).toBeDefined();
    expect(api.sessions).toBeDefined();
    expect(api.fields).toBeDefined();
    expect(api.fieldData).toBeDefined();
    expect(api.groups).toBeDefined();
    expect(api.newsFeedLinks).toBeDefined();
    expect(api.groupMessages).toBeDefined();
    expect(api.groupMessageComments).toBeDefined();
    expect(api.groupMembers).toBeDefined();
    expect(api.policyGroups).toBeDefined();
  });
});
