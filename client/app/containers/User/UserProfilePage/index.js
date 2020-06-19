import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getUserBegin, userUnmount
} from 'containers/User/actions';

import { selectUser, selectFieldData, selectIsFormLoading } from 'containers/User/selectors';

import saga from 'containers/User/saga';
import Profile from 'components/User/Profile';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/User/messages';

export function UserProfilePage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });
  const { intl } = props;

  const { user_id: userId } = useParams();

  const links = {
    userEdit: id => ROUTES.user.edit.path(id),
  };

  useEffect(() => {
    props.getUserBegin({ id: userId });

    return () => {
      props.userUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <Profile
        links={links}
        user={props.user}
        fieldData={props.fieldData}
        buttonText={intl.formatMessage(messages.update)}
        isFormLoading={props.isFormLoading}
      />
    </React.Fragment>
  );
}

UserProfilePage.propTypes = {
  intl: intlShape,
  path: PropTypes.string,
  user: PropTypes.object,
  fieldData: PropTypes.array,
  getUserBegin: PropTypes.func,
  userUnmount: PropTypes.func,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  user: selectUser(),
  fieldData: selectFieldData(),
  isFormLoading: selectIsFormLoading(),
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
  injectIntl,
  withConnect,
  memo,
)(UserProfilePage);
