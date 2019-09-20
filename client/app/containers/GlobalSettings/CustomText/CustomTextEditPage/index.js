import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/CustomText/reducer';
import appReducer from 'containers/Shared/App/reducer';
import saga from 'containers/GlobalSettings/CustomText/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectUser, selectCustomText } from 'containers/Shared/App/selectors';

import {
  getCustomTextBegin, updateCustomTextBegin,
  customTextUnmount
} from 'containers/GlobalSettings/CustomText/actions';

import CustomTextForm from 'components/GlobalSettings/CustomText/CustomTextForm';

export function CustomTextEditPage(props) {
  useInjectReducer({ key: 'custom_text', reducer });
  // useInjectReducer({ key: 'app', appReducer });
  useInjectSaga({ key: 'custom_text', saga });

  const rs = new RouteService(useContext);
  const links = {
    customTextEdit: ROUTES.admin.system.globalSettings.customText.edit.path()
  };

  const { currentUser } = props;
  const { customText } = props;

  return (
    <CustomTextForm
      customTextAction={props.updateCustomTextBegin}
      buttonText='Update'
      currentUser={currentUser}
      links={links}
      customText={customText}
    />
  );
}

CustomTextEditPage.propTypes = {
  getCustomTextBegin: PropTypes.func,
  updateCustomTextBegin: PropTypes.func,
  customTextUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  customText: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  customText: selectCustomText(),
});

const mapDispatchToProps = {
  getCustomTextBegin,
  updateCustomTextBegin,
  customTextUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CustomTextEditPage);
