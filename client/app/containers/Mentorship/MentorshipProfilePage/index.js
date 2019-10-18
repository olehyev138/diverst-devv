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
  getUserBegin, userUnmount
} from 'containers/Mentorship/actions';

import { selectUser } from 'containers/Mentorship/selectors';

import saga from 'containers/Mentorship/saga';
import Profile from 'components/Mentorship/MentorshipUser';
import dig from 'object-dig';

export function UserProfilePage(props) {
  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

  const rs = new RouteService(useContext);

  return (
    <React.Fragment>
      <Profile
        user={props.user}
      />
    </React.Fragment>
  );
}

UserProfilePage.propTypes = {
  path: PropTypes.string,
  user: PropTypes.object,
  getUserBegin: PropTypes.func,
  userUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  getUserBegin,
  userUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserProfilePage);
