import enterprises from 'api/enterprises/enterprises';
import mockAxios from 'axios';
jest.mock('axios');

describe('Enterprise API Calls', () => {
  afterEach(() => {
    jest.resetAllMocks();
  });

  it('calls GET function', async () => {
    const response = {
      data: { page: { total: 1, type: 'usergroup', items: [{ id: 1 }] } }
    };
    mockAxios.get.mockImplementationOnce(() => Promise.resolve(response));
    const payload = {
      page: 1, count: 10, order: 'desc', orderBy: 'enterprises.created_at'
    };
    const page = await enterprises.all(payload);

    expect(page).toEqual(response);
    expect(mockAxios.get).toHaveBeenCalledTimes(1);
    expect(mockAxios.get).toHaveBeenCalledWith('undefined/api/v1/enterprises?page=1&count=10&order=desc&orderBy=enterprises.created_at');
  });

  it('calls GET function', async () => {
    const response = {
      data: { user_group: { id: 1 } }
    };
    mockAxios.get.mockImplementationOnce(() => Promise.resolve(response));

    const page = await enterprises.get(1);

    expect(page).toEqual(response);
    expect(mockAxios.get).toHaveBeenCalledTimes(1);
    expect(mockAxios.get).toHaveBeenCalledWith('undefined/api/v1/enterprises/1');
  });

  it('calls POST function', async () => {
    const response = {
      data: { user_group: { id: 1 } }
    };
    mockAxios.post.mockImplementationOnce(() => Promise.resolve(response));

    const payload = {};
    const page = await enterprises.create(payload);

    expect(page).toEqual(response);
    expect(mockAxios.post).toHaveBeenCalledTimes(1);
    expect(mockAxios.post).toHaveBeenCalledWith('undefined/api/v1/enterprises', {});
  });

  it('calls PUT function', async () => {
    const response = {
      data: { user_group: { id: 1 } }
    };
    mockAxios.put.mockImplementationOnce(() => Promise.resolve(response));

    const payload = {};
    const page = await enterprises.update(1, payload);

    expect(page).toEqual(response);
    expect(mockAxios.put).toHaveBeenCalledTimes(1);
    expect(mockAxios.put).toHaveBeenCalledWith('undefined/api/v1/enterprises/1', {});
  });

  it('calls DELETE function', async () => {
    const response = {
      data: null
    };
    mockAxios.delete.mockImplementationOnce(() => Promise.resolve(response));

    const page = await enterprises.destroy(1);

    expect(page).toEqual(response);
    expect(mockAxios.delete).toHaveBeenCalledTimes(1);
    expect(mockAxios.delete).toHaveBeenCalledWith('undefined/api/v1/enterprises/1');
  });

  it('calls POST function', async () => {
    const response = {
      data: { user_group: { id: 1 } }
    };
    mockAxios.post.mockImplementationOnce(() => Promise.resolve(response));

    const payload = {};
    const page = await enterprises.getSsoLink(1, payload);

    expect(page).toEqual(response);
    expect(mockAxios.post).toHaveBeenCalledTimes(1);
    expect(mockAxios.post).toHaveBeenCalledWith('undefined/api/v1/enterprises/1/sso_link', {});
  });
});
