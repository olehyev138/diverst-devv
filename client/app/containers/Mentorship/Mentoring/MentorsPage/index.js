/**
 *
 * MentorsPage
 *
 *  - lists all enterprise custom users
 *  - renders forms for creating & editing custom users
 *
 *  - function:
 *    - get users from server
 *    - on edit - render respective form with user data
 *    - on new - render respective empty form
 *    - on save - create/update user
 */

import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';

import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectPaginatedMentors,
  selectMentorTotal,
  selectIsFetchingMentors,
  selectPaginatedMentees,
  selectMenteeTotal,
  selectIsFetchingMentees,
  selectPaginatedAvailableMentors,
  selectPaginatedAvailableMentees,
  selectAvailableMentorTotal,
  selectAvailableMenteeTotal,
  selectIsFetchingAvailableMentors,
  selectIsFetchingAvailableMentees,
} from 'containers/Mentorship/Mentoring/selectors';
import {
  getMentorsBegin, getMenteesBegin,
  getAvailableMentorsBegin, getAvailableMenteesBegin,
  mentorsUnmount
} from 'containers/Mentorship/Mentoring/actions';

import reducer from 'containers/Mentorship/Mentoring/reducer';
import saga from 'containers/Mentorship/Mentoring/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MentorList from 'components/Mentorship/MentorList';

export function MentorsPage(props) {
  useInjectReducer({ key: 'mentoring', reducer });
  useInjectSaga({ key: 'mentoring', saga });
  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });
  const rs = new RouteService(useContext);

  useEffect(() => {
    if (props.user) {
      const userId = props.user.id;
      if (props.type === 'mentees') {
        props.getMenteesBegin({ ...params, userId });
        props.getAvailableMenteesBegin({ ...params, userId, query_scopes: ['mentees'] });
      } else {
        props.getMentorsBegin({ ...params, userId });
        props.getAvailableMentorsBegin({ ...params, userId, query_scopes: ['mentors'] });
      }
    }
    return () => {
      props.mentorsUnmount();
    };
  }, []);

  const links = {
    userNew: ROUTES.admin.system.users.new.path(),
    userEdit: id => ROUTES.admin.system.users.edit.path(id),
  };

  const handleMentorPagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getMentorsBegin(newParams);
    setParams(newParams);
  };

  const handleMentorOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getMentorsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <MentorList
        user={props.user}
        userParams={params}

        users={props.type === 'mentees' ? props.mentees : props.mentors}
        userTotal={props.type === 'mentees' ? props.menteeTotal : props.mentorTotal}
        isFetchingUsers={props.isFetchingMentors || props.isFetchingMentees}

        availableUsers={props.type === 'mentees' ? props.availableMentees : props.availableMentors}
        availableUserTotal={props.type === 'mentees' ? props.availableMenteeTotal : props.availableMentorTotal}
        isFetchingAvailableUsers={props.isFetchingAvailableMentors || props.isFetchingAvailableMentees}

        handleMentorPagination={handleMentorPagination}
        handleMentorOrdering={handleMentorOrdering}
        type={props.type}
        links={links}
      />
    </React.Fragment>
  );
}

MentorsPage.propTypes = {
  type: PropTypes.string,
  getMentorsBegin: PropTypes.func.isRequired,
  getMenteesBegin: PropTypes.func.isRequired,
  mentors: PropTypes.array,
  mentees: PropTypes.array,
  mentorTotal: PropTypes.number,
  menteeTotal: PropTypes.number,
  isFetchingMentors: PropTypes.bool,
  isFetchingMentees: PropTypes.bool,
  user: PropTypes.object,
  getAvailableMentorsBegin: PropTypes.func.isRequired,
  getAvailableMenteesBegin: PropTypes.func.isRequired,
  availableMentors: PropTypes.array,
  availableMentees: PropTypes.array,
  availableMentorTotal: PropTypes.number,
  availableMenteeTotal: PropTypes.number,
  isFetchingAvailableMentors: PropTypes.bool,
  isFetchingAvailableMentees: PropTypes.bool,
  mentorsUnmount: PropTypes.func.isRequired,
};

const mapStateToProps = createStructuredSelector({
  mentors: selectPaginatedMentors(),
  mentees: selectPaginatedMentees(),
  mentorTotal: selectMentorTotal(),
  menteeTotal: selectMenteeTotal(),
  isFetchingMentors: selectIsFetchingMentors(),
  isFetchingMentees: selectIsFetchingMentees(),
  availableMentors: selectPaginatedAvailableMentors(),
  availableMentees: selectPaginatedAvailableMentees(),
  availableMentorTotal: selectAvailableMentorTotal(),
  availableMenteeTotal: selectAvailableMenteeTotal(),
  isFetchingAvailableMentors: selectIsFetchingAvailableMentors(),
  isFetchingAvailableMentees: selectIsFetchingAvailableMentees(),
});

const mapDispatchToProps = {
  getMentorsBegin,
  getMenteesBegin,
  getAvailableMentorsBegin,
  getAvailableMenteesBegin,
  mentorsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MentorsPage);
