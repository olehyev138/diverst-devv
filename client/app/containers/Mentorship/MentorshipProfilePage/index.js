import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/reducer';

import {
  getUserBegin, userUnmount
} from 'containers/Mentorship/actions';

import saga from 'containers/Mentorship/saga';
import Profile from 'components/Mentorship/MentorshipUser';

export function UserProfilePage(props) {
  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

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
