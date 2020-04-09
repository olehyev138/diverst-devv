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
import { selectMentoringInterests, selectMentoringTypes, selectUser } from 'containers/Shared/App/selectors';

import saga from 'containers/Mentorship/saga';
import MentorshipUserForm from 'components/Mentorship/MentorshipUserForm';
import Conditional from 'components/Compositions/Conditional';

import dig from 'object-dig';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function MentorshipEditProfilePage(props) {
  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

  const rs = new RouteService(useContext);

  return (
    <React.Fragment>
      <MentorshipUserForm
        user={props.formUser}
        userSession={props.userSession}
        userAction={props.updateUserBegin}
        interestOptions={props.interestOptions}
        typeOptions={props.typeOptions}
      />
    </React.Fragment>
  );
}

MentorshipEditProfilePage.propTypes = {
  updateUserBegin: PropTypes.func,
  path: PropTypes.string,
  user: PropTypes.object,
  userSession: PropTypes.shape({
    id: PropTypes.number
  }).isRequired,
  formUser: PropTypes.object,
  getUserBegin: PropTypes.func,
  userUnmount: PropTypes.func,
  interestOptions: PropTypes.array,
  typeOptions: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  formUser: selectFormUser(),
  sessionUser: selectUser(),
  interestOptions: selectMentoringInterests(),
  typeOptions: selectMentoringTypes()
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
)(Conditional(
  MentorshipEditProfilePage,
  ['formUser.permissions.update?'],
  (props, rs) => ROUTES.user.mentorship.show.path(dig(props, 'sessionUser', 'user_id')),
  permissionMessages.mentorship.editProfilePage,
  true
));
