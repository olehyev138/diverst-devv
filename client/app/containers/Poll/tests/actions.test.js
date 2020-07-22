import {
  GET_POLL_BEGIN,
  GET_POLL_SUCCESS,
  GET_POLL_ERROR,
  GET_POLLS_BEGIN,
  GET_POLLS_SUCCESS,
  GET_POLLS_ERROR,
  CREATE_POLL_BEGIN,
  CREATE_POLL_SUCCESS,
  CREATE_POLL_ERROR,
  UPDATE_POLL_BEGIN,
  UPDATE_POLL_SUCCESS,
  UPDATE_POLL_ERROR,
  CREATE_POLL_AND_PUBLISH_BEGIN,
  CREATE_POLL_AND_PUBLISH_SUCCESS,
  CREATE_POLL_AND_PUBLISH_ERROR,
  UPDATE_POLL_AND_PUBLISH_BEGIN,
  UPDATE_POLL_AND_PUBLISH_SUCCESS,
  UPDATE_POLL_AND_PUBLISH_ERROR,
  PUBLISH_POLL_BEGIN,
  PUBLISH_POLL_SUCCESS,
  PUBLISH_POLL_ERROR,
  DELETE_POLL_BEGIN,
  DELETE_POLL_SUCCESS,
  DELETE_POLL_ERROR,
  POLLS_UNMOUNT,
} from '../constants';

import {
  getPollBegin,
  getPollSuccess,
  getPollError,
  getPollsBegin,
  getPollsSuccess,
  getPollsError,
  createPollBegin,
  createPollSuccess,
  createPollError,
  updatePollBegin,
  updatePollSuccess,
  updatePollError,
  createPollAndPublishBegin,
  createPollAndPublishSuccess,
  createPollAndPublishError,
  updatePollAndPublishBegin,
  updatePollAndPublishSuccess,
  updatePollAndPublishError,
  publishPollBegin,
  publishPollSuccess,
  publishPollError,
  deletePollBegin,
  deletePollSuccess,
  deletePollError,
  pollsUnmount,
} from '../actions';

describe('poll actions', () => {
  describe('poll getting actions', () => {
    describe('getPollBegin', () => {
      it('has a type of GET_POLL_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_POLL_BEGIN,
          payload: { value: 301 }
        };

        expect(getPollBegin({ value: 301 })).toEqual(expected);
      });
    });

    describe('getPollSuccess', () => {
      it('has a type of GET_POLL_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_POLL_SUCCESS,
          payload: { value: 542 }
        };

        expect(getPollSuccess({ value: 542 })).toEqual(expected);
      });
    });

    describe('getPollError', () => {
      it('has a type of GET_POLL_ERROR and sets a given error', () => {
        const expected = {
          type: GET_POLL_ERROR,
          error: { value: 966 }
        };

        expect(getPollError({ value: 966 })).toEqual(expected);
      });
    });
  });

  describe('poll list actions', () => {
    describe('getPollsBegin', () => {
      it('has a type of GET_POLLS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_POLLS_BEGIN,
          payload: { value: 856 }
        };

        expect(getPollsBegin({ value: 856 })).toEqual(expected);
      });
    });

    describe('getPollsSuccess', () => {
      it('has a type of GET_POLLS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_POLLS_SUCCESS,
          payload: { value: 923 }
        };

        expect(getPollsSuccess({ value: 923 })).toEqual(expected);
      });
    });

    describe('getPollsError', () => {
      it('has a type of GET_POLLS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_POLLS_ERROR,
          error: { value: 824 }
        };

        expect(getPollsError({ value: 824 })).toEqual(expected);
      });
    });
  });

  describe('poll creating actions', () => {
    describe('createPollBegin', () => {
      it('has a type of CREATE_POLL_BEGIN and sets a given payload', () => {
        const expected = {
          type: CREATE_POLL_BEGIN,
          payload: { value: 587 }
        };

        expect(createPollBegin({ value: 587 })).toEqual(expected);
      });
    });

    describe('createPollSuccess', () => {
      it('has a type of CREATE_POLL_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_POLL_SUCCESS,
          payload: { value: 587 }
        };

        expect(createPollSuccess({ value: 587 })).toEqual(expected);
      });
    });

    describe('createPollError', () => {
      it('has a type of CREATE_POLL_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_POLL_ERROR,
          error: { value: 551 }
        };

        expect(createPollError({ value: 551 })).toEqual(expected);
      });
    });
  });

  describe('poll updating actions', () => {
    describe('updatePollBegin', () => {
      it('has a type of UPDATE_POLL_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_POLL_BEGIN,
          payload: { value: 909 }
        };

        expect(updatePollBegin({ value: 909 })).toEqual(expected);
      });
    });

    describe('updatePollSuccess', () => {
      it('has a type of UPDATE_POLL_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_POLL_SUCCESS,
          payload: { value: 595 }
        };

        expect(updatePollSuccess({ value: 595 })).toEqual(expected);
      });
    });

    describe('updatePollError', () => {
      it('has a type of UPDATE_POLL_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_POLL_ERROR,
          error: { value: 179 }
        };

        expect(updatePollError({ value: 179 })).toEqual(expected);
      });
    });
  });

  describe('poll create and publishing actions', () => {
    describe('createPollAndPublishBegin', () => {
      it('has a type of CREATE_POLL_AND_PUBLISH_BEGIN and sets a given payload', () => {
        const expected = {
          type: CREATE_POLL_AND_PUBLISH_BEGIN,
          payload: { value: 79 }
        };

        expect(createPollAndPublishBegin({ value: 79 })).toEqual(expected);
      });
    });

    describe('createPollAndPublishSuccess', () => {
      it('has a type of CREATE_POLL_AND_PUBLISH_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_POLL_AND_PUBLISH_SUCCESS,
          payload: { value: 841 }
        };

        expect(createPollAndPublishSuccess({ value: 841 })).toEqual(expected);
      });
    });

    describe('createPollAndPublishError', () => {
      it('has a type of CREATE_POLL_AND_PUBLISH_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_POLL_AND_PUBLISH_ERROR,
          error: { value: 398 }
        };

        expect(createPollAndPublishError({ value: 398 })).toEqual(expected);
      });
    });
  });

  describe('poll update and publishing actions', () => {
    describe('updatePollAndPublishBegin', () => {
      it('has a type of UPDATE_POLL_AND_PUBLISH_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_POLL_AND_PUBLISH_BEGIN,
          payload: { value: 833 }
        };

        expect(updatePollAndPublishBegin({ value: 833 })).toEqual(expected);
      });
    });

    describe('updatePollAndPublishSuccess', () => {
      it('has a type of UPDATE_POLL_AND_PUBLISH_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_POLL_AND_PUBLISH_SUCCESS,
          payload: { value: 811 }
        };

        expect(updatePollAndPublishSuccess({ value: 811 })).toEqual(expected);
      });
    });

    describe('updatePollAndPublishError', () => {
      it('has a type of UPDATE_POLL_AND_PUBLISH_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_POLL_AND_PUBLISH_ERROR,
          error: { value: 305 }
        };

        expect(updatePollAndPublishError({ value: 305 })).toEqual(expected);
      });
    });
  });

  describe('poll publishing actions', () => {
    describe('publishPollBegin', () => {
      it('has a type of PUBLISH_POLL_BEGIN and sets a given payload', () => {
        const expected = {
          type: PUBLISH_POLL_BEGIN,
          payload: { value: 755 }
        };

        expect(publishPollBegin({ value: 755 })).toEqual(expected);
      });
    });

    describe('publishPollSuccess', () => {
      it('has a type of PUBLISH_POLL_SUCCESS and sets a given payload', () => {
        const expected = {
          type: PUBLISH_POLL_SUCCESS,
          payload: { value: 797 }
        };

        expect(publishPollSuccess({ value: 797 })).toEqual(expected);
      });
    });

    describe('publishPollError', () => {
      it('has a type of PUBLISH_POLL_ERROR and sets a given error', () => {
        const expected = {
          type: PUBLISH_POLL_ERROR,
          error: { value: 37 }
        };

        expect(publishPollError({ value: 37 })).toEqual(expected);
      });
    });
  });

  describe('poll deleting actions', () => {
    describe('deletePollBegin', () => {
      it('has a type of DELETE_POLL_BEGIN and sets a given payload', () => {
        const expected = {
          type: DELETE_POLL_BEGIN,
          payload: { value: 100 }
        };

        expect(deletePollBegin({ value: 100 })).toEqual(expected);
      });
    });

    describe('deletePollSuccess', () => {
      it('has a type of DELETE_POLL_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DELETE_POLL_SUCCESS,
          payload: { value: 404 }
        };

        expect(deletePollSuccess({ value: 404 })).toEqual(expected);
      });
    });

    describe('deletePollError', () => {
      it('has a type of DELETE_POLL_ERROR and sets a given error', () => {
        const expected = {
          type: DELETE_POLL_ERROR,
          error: { value: 196 }
        };

        expect(deletePollError({ value: 196 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('pollsUnmount', () => {
      it('has a type of POLLS_UNMOUNT', () => {
        const expected = {
          type: POLLS_UNMOUNT,
        };

        expect(pollsUnmount()).toEqual(expected);
      });
    });
  });
});
