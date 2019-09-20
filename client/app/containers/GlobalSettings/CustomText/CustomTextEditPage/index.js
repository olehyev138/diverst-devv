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

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectUser, selectCustomText } from 'containers/Shared/App/selectors';

import {
  updateCustomTextBegin,
} from 'containers/GlobalSettings/CustomText/actions';

import CustomTextForm from 'components/GlobalSettings/CustomText/CustomTextForm';

export function CustomTextEditPage(props) {
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
  currentUser: PropTypes.object,
  customText: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  customText: selectCustomText(),
});

const mapDispatchToProps = {
  updateCustomTextBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CustomTextEditPage);
