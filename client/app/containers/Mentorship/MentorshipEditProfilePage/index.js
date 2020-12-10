import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/reducer';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getUserBegin, userUnmount, updateUserBegin
} from 'containers/Mentorship/actions';

import { selectFormUser } from 'containers/Mentorship/selectors';
import { selectCustomText, selectMentoringInterests, selectMentoringTypes, selectUser } from '../../Shared/App/selectors';


import saga from 'containers/Mentorship/saga';
import MentorshipUserForm from 'components/Mentorship/MentorshipUserForm';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function MentorshipEditProfilePage(props) {
  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

  return (
    <React.Fragment>
      <MentorshipUserForm
        user={props.formUser}
        userSession={props.userSession}
        userAction={props.updateUserBegin}
        interestOptions={props.interestOptions}
        typeOptions={props.typeOptions}
        customTexts={props.customTexts}
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
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  formUser: selectFormUser(),
  sessionUser: selectUser(),
  interestOptions: selectMentoringInterests(),
  typeOptions: selectMentoringTypes(),
  customTexts: selectCustomText()
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
  (props, params) => ROUTES.user.mentorship.show.path(props?.sessionUser?.user_id),
  permissionMessages.mentorship.editProfilePage,
  true
));
