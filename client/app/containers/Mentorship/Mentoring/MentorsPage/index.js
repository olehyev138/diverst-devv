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
} from 'containers/Mentorship/Mentoring/selectors';
import {
  getMentorsBegin, getMenteesBegin, mentorsUnmount
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
      if (props.type === 'mentees')
        props.getMenteesBegin({ ...params, userId });
      else
        props.getMentorsBegin({ ...params, userId });
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
        users={props.type === 'mentees' ? props.mentees : props.mentors}
        userTotal={props.type === 'mentees' ? props.menteeTotal : props.mentorTotal}
        isFetchingUsers={props.isFetchingMentor || props.isFetchingMentee}
        userParams={params}
        handleMentorPagination={handleMentorPagination}
        handleMentorOrdering={handleMentorOrdering}
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
  user: PropTypes.object,
  isFetchingMentor: PropTypes.bool,
  isFetchingMentee: PropTypes.bool,
  mentorsUnmount: PropTypes.func.isRequired,
};

const mapStateToProps = createStructuredSelector({
  mentors: selectPaginatedMentors(),
  mentees: selectPaginatedMentees(),
  mentorTotal: selectMentorTotal(),
  menteeTotal: selectMenteeTotal(),
  isFetchingMentor: selectIsFetchingMentors(),
  isFetchingMentee: selectIsFetchingMentees(),
});

const mapDispatchToProps = {
  getMentorsBegin,
  getMenteesBegin,
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
