import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getUserBegin, updateFieldDataBegin,
  updateUserBegin, userUnmount
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
  const rs = new RouteService(useContext);
  const links = {
    userEdit: id => ROUTES.user.edit.path(id),
  };

  useEffect(() => {
    props.getUserBegin({ id: rs.params('user_id') });

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
  intl: intlShape.isRequired,
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
