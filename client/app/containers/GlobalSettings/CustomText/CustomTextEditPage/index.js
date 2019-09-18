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
import saga from 'containers/GlobalSettings/CustomText/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectUser } from 'containers/Shared/App/selectors';

import {
  getCustomTextBegin, updateCustomTextBegin,
  customTextUnmount
} from 'containers/GlobalSettings/CustomText/actions';

import CustomTextForm from 'components/GlobalSettings/CustomText/CustomTextForm';

export function CustomTextEditPage(props) {
  useInjectReducer({ key: 'custom_text', reducer });
  useInjectSaga({ key: 'custom_text', saga });

  const rs = new RouteService(useContext);
  const links = {
    customTextEdit: ROUTES.admin.system.globalSettings.customText.edit.path()
  };
  console.log(props);
  useEffect(() => {
    const newsItemId = rs.params('item_id');
    props.getCustomTextBegin({ id: newsItemId });

    return () => props.customTextUnmount();
  }, []);

  const { currentUser } = props;

  return (
    <CustomTextForm
      customTextAction={props.updateCustomTextBegin}
      buttonText='Update'
      currentUser={currentUser}
      links={links}
    />
  );
}

CustomTextEditPage.propTypes = {
  getCustomTextBegin: PropTypes.func,
  updateCustomTextBegin: PropTypes.func,
  customTextUnmount: PropTypes.func,
  currentUser: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
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
