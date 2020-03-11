import policyGroups from 'api/policy_group_templates/policy_group_templates';
import mockAxios from 'axios';
jest.mock('axios');

describe('PolicyGroup API Calls', () => {
  afterEach(() => {
    jest.resetAllMocks();
  });

  it('calls GET function', async () => {
    const response = {
      data: { page: { total: 1, type: 'usergroup', items: [{ id: 1 }] } }
    };
    mockAxios.get.mockImplementationOnce(() => Promise.resolve(response));
    const payload = {
      page: 1, count: 10, order: 'desc', orderBy: 'policy_group_templates.created_at'
    };
    const page = await policyGroups.all(payload);

    expect(page).toEqual(response);
    expect(mockAxios.get).toHaveBeenCalledTimes(1);
    expect(mockAxios.get).toHaveBeenCalledWith('/api/v1/policy_group_templates?page=1&count=10&order=desc&orderBy=policy_group_templates.created_at');
  });

  it('calls GET function', async () => {
    const response = {
      data: { user_group: { id: 1 } }
    };
    mockAxios.get.mockImplementationOnce(() => Promise.resolve(response));

    const page = await policyGroups.get(1);

    expect(page).toEqual(response);
    expect(mockAxios.get).toHaveBeenCalledTimes(1);
    expect(mockAxios.get).toHaveBeenCalledWith('/api/v1/policy_group_templates/1');
  });

  it('calls POST function', async () => {
    const response = {
      data: { user_group: { id: 1 } }
    };
    mockAxios.post.mockImplementationOnce(() => Promise.resolve(response));

    const payload = {};
    const page = await policyGroups.create(payload);

    expect(page).toEqual(response);
    expect(mockAxios.post).toHaveBeenCalledTimes(1);
    expect(mockAxios.post).toHaveBeenCalledWith('/api/v1/policy_group_templates', {});
  });

  it('calls PUT function', async () => {
    const response = {
      data: { user_group: { id: 1 } }
    };
    mockAxios.put.mockImplementationOnce(() => Promise.resolve(response));

    const payload = {};
    const page = await policyGroups.update(1, payload);

    expect(page).toEqual(response);
    expect(mockAxios.put).toHaveBeenCalledTimes(1);
    expect(mockAxios.put).toHaveBeenCalledWith('/api/v1/policy_group_templates/1', {});
  });

  it('calls DELETE function', async () => {
    const response = {
      data: null
    };
    mockAxios.delete.mockImplementationOnce(() => Promise.resolve(response));

    const page = await policyGroups.destroy(1);

    expect(page).toEqual(response);
    expect(mockAxios.delete).toHaveBeenCalledTimes(1);
    expect(mockAxios.delete).toHaveBeenCalledWith('/api/v1/policy_group_templates/1');
  });
});
