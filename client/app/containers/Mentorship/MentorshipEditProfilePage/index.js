import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getUserBegin, userUnmount, updateUserBegin
} from 'containers/Mentorship/actions';

import { selectFormUser } from 'containers/Mentorship/selectors';

import saga from 'containers/Mentorship/saga';
import MentorshipUserForm from 'components/Mentorship/MentorshipUserForm';

export function UserProfilePage(props) {
  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

  const rs = new RouteService(useContext);

  return (
    <React.Fragment>
      <MentorshipUserForm
        user={props.user}
        userAction={props.updateUserBegin}
      />
    </React.Fragment>
  );
}

UserProfilePage.propTypes = {
  updateUserBegin: PropTypes.func,
  path: PropTypes.string,
  user: PropTypes.object,
  getUserBegin: PropTypes.func,
  userUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  getUserBegin,
  userUnmount,
  updateUserBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserProfilePage);
