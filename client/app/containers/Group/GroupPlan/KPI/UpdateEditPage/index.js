/**
 *
 * UpdatePage
 *
 *  - lists all enterprise custom updates
 *  - renders forms for creating & editing custom updates
 *
 *  - function:
 *    - get updates from server
 *    - on edit - render respective form with update data
 *    - on new - render respective empty form
 *    - on save - create/update update
 */

import React, { memo, useContext, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import dig from 'object-dig';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectUpdate,
  selectIsFetchingUpdate,
  selectIsCommitting,
} from 'containers/Shared/Update/selectors';

import {
  selectIsCommitting as selectIsCommittingFieldData,
} from 'containers/Shared/FieldData/selectors';

import {
  getUpdateBegin,
  deleteUpdateBegin,
  updatesUnmount,
  updateUpdateBegin,
} from 'containers/Shared/Update/actions';

import reducer from 'containers/Shared/Update/reducer';
import saga from '../updatesSaga';

import { ROUTES } from 'containers/Shared/Routes/constants';
import RouteService from 'utils/routeHelpers';

export function UpdateEditPage(props) {
  useInjectReducer({ key: 'updates', reducer });
  useInjectSaga({ key: 'updates', saga });

  const rs = new RouteService(useContext);
  const { location } = rs;

  const partialLink = ROUTES.group.plan.kpi.updates;
  const links = {
    new: partialLink.new.path(dig(props, 'currentGroup', 'id')),
    edit: id => partialLink.edit.path(dig(props, 'currentGroup', 'id'), id),
    show: id => partialLink.show.path(dig(props, 'currentGroup', 'id'), id),
  };

  const update = props.currentUpdate || location.update;

  useEffect(() => {
    const [id] = rs.params('update_id');
    if (!update || update.id !== id)
      props.getUpdateBegin(id);

    return () => {
      props.updatesUnmount();
    };
  }, []);

  return (
    <h1>
      {`EDIT ITEM ${dig(update, 'id')}`}
    </h1>
  );
}

UpdateEditPage.propTypes = {
  getUpdateBegin: PropTypes.func.isRequired,
  deleteUpdateBegin: PropTypes.func.isRequired,
  updatesUnmount: PropTypes.func.isRequired,
  updateUpdateBegin: PropTypes.func.isRequired,

  currentUpdate: PropTypes.object,
  isFetching: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isCommittingFieldData: PropTypes.bool,

  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  currentUpdate: selectUpdate(),
  isFetching: selectIsFetchingUpdate(),
  isCommitting: selectIsCommitting(),
  isCommittingFieldData: selectIsCommittingFieldData(),
});

const mapDispatchToProps = {
  getUpdateBegin,
  updateUpdateBegin,
  deleteUpdateBegin,
  updatesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UpdateEditPage);
