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
  selectUser,
} from 'containers/Mentorship/selectors';
import {
  getMentorsBegin, mentorsUnmount
} from 'containers/Mentorship/actions';

import reducer from 'containers/Mentorship/reducer';
import saga from 'containers/Mentorship/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MentorList from 'components/Mentorship/MentorList';

export function MentorsPage(props) {
  // useInjectReducer({ key: 'mentorship', reducer });
  // useInjectSaga({ key: 'mentorship', saga });
  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });
  const rs = new RouteService(useContext);
  // const [userId] = rs.params('user_id');

  useEffect(() => {
    if (props.user) {
      const userId = props.user.id;
      props.getMentorsBegin({ ...params, userId });
    }
    return () => {
      console.log('aa_unmountMentor');
      // props.mentorsUnmount();
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
      {/*<MentorList*/}
      {/*  mentors={props.mentors}*/}
      {/*  mentorTotal={props.mentorTotal}*/}
      {/*  isFetchingMentors={props.isFetchingMentor}*/}
      {/*  mentorParams={params}*/}
      {/*  handleMentorPagination={handleMentorPagination}*/}
      {/*  handleMentorOrdering={handleMentorOrdering}*/}
      {/*  links={links}*/}
      {/*/>*/}
      {props.user && (
        `${props.user.id}`
      )}
    </React.Fragment>
  );
}

MentorsPage.propTypes = {
  getMentorsBegin: PropTypes.func.isRequired,
  mentors: PropTypes.array,
  mentorTotal: PropTypes.number,
  user: PropTypes.object,
  isFetchingMentor: PropTypes.bool,
  mentorsUnmount: PropTypes.func.isRequired,
};

const mapStateToProps = createStructuredSelector({
  mentors: selectPaginatedMentors(),
  mentorTotal: selectMentorTotal(),
  isFetchingMentor: selectIsFetchingMentors(),
});

const mapDispatchToProps = {
  getMentorsBegin,
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
