import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/GlobalSettings/CustomText/saga';
import reducer from 'containers/GlobalSettings/CustomText/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectIsCommitting } from 'containers/GlobalSettings/CustomText/selectors';
import { selectUser, selectCustomText, selectPermissions } from 'containers/Shared/App/selectors';

import {
  updateCustomTextBegin,
} from 'containers/GlobalSettings/CustomText/actions';

import CustomTextForm from 'components/GlobalSettings/CustomText/CustomTextForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/GlobalSettings/CustomText/messages';
import Conditional from 'components/Compositions/Conditional';
import { UserListPage } from 'containers/User/UsersPage';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CustomTextEditPage(props) {
  useInjectReducer({ key: 'custom_text', reducer });
  useInjectSaga({ key: 'custom_text', saga });

  const rs = new RouteService(useContext);
  const links = {
    customTextEdit: ROUTES.admin.system.globalSettings.customText.edit.path()
  };
  const { intl } = props;
  const { currentUser } = props;
  const { customText } = props;

  return (
    <CustomTextForm
      customTextAction={props.updateCustomTextBegin}
      buttonText={intl.formatMessage(messages.update)}
      currentUser={currentUser}
      links={links}
      customText={customText}
      isCommitting={props.isCommitting}
    />
  );
}

CustomTextEditPage.propTypes = {
  intl: intlShape,
  getCustomTextBegin: PropTypes.func,
  updateCustomTextBegin: PropTypes.func,
  currentUser: PropTypes.object,
  customText: PropTypes.object,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  customText: selectCustomText(),
  isCommitting: selectIsCommitting(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  updateCustomTextBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  CustomTextEditPage,
  ['permissions.custom_text_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.globalSettings.customText.editPage
));
