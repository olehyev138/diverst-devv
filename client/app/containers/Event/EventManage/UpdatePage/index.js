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
  getUpdateSuccess,
  deleteUpdateBegin,
  updatesUnmount,
  updateUpdateBegin,
} from 'containers/Shared/Update/actions';

import {
  updateFieldDataBegin
} from 'containers/Shared/FieldData/actions';

import reducer from 'containers/Shared/Update/reducer';
import saga from '../updatesSaga';

import fieldDataReducer from 'containers/Shared/FieldData/reducer';
import fieldDataSaga from 'containers/Shared/FieldData/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';
import RouteService from 'utils/routeHelpers';

import Update from 'components/Shared/Updates/Update';
import { selectEvent } from 'containers/Event/selectors';

export function UpdateEditPage(props) {
  useInjectReducer({ key: 'updates', reducer });
  useInjectSaga({ key: 'updates', saga });
  useInjectReducer({ key: 'field_data', reducer: fieldDataReducer });
  useInjectSaga({ key: 'field_data', saga: fieldDataSaga });

  const rs = new RouteService(useContext);
  const { location } = rs;

  const partialLink = ROUTES.group.plan.event.updates;
  const links = {
    index: partialLink.index.path(dig(props, 'currentEvent', 'id')),
    edit: id => partialLink.edit.path(dig(props, 'currentEvent', 'id'), id),
    show: id => partialLink.show.path(dig(props, 'currentEvent', 'id'), id),
  };

  const update = props.currentUpdate || location.update;

  useEffect(() => {
    const id = rs.params('update_id');
    // eslint-disable-next-line eqeqeq
    if (!update || update.id != id)
      props.getUpdateBegin(id);
    else
      props.getUpdateSuccess({ update });

    return () => {
      props.updatesUnmount();
    };
  }, []);

  return (
    <Update
      update={update}
      links={links}
      isFetching={props.isFetching}
    />
  );
}

UpdateEditPage.propTypes = {
  getUpdateBegin: PropTypes.func.isRequired,
  getUpdateSuccess: PropTypes.func.isRequired,
  deleteUpdateBegin: PropTypes.func.isRequired,
  updatesUnmount: PropTypes.func.isRequired,
  updateUpdateBegin: PropTypes.func.isRequired,
  updateFieldDataBegin: PropTypes.func.isRequired,

  currentUpdate: PropTypes.object,
  isFetching: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isCommittingFieldData: PropTypes.bool,

  currentEvent: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  currentUpdate: selectUpdate(),
  currentEvent: selectEvent(),
  isFetching: selectIsFetchingUpdate(),
  isCommitting: selectIsCommitting(),
  isCommittingFieldData: selectIsCommittingFieldData(),
});

const mapDispatchToProps = {
  getUpdateBegin,
  getUpdateSuccess,
  updateUpdateBegin,
  deleteUpdateBegin,
  updatesUnmount,
  updateFieldDataBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UpdateEditPage);
