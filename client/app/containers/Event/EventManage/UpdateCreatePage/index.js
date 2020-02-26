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
  createUpdateBegin,
  updatesUnmount,
  getUpdatePrototypeBegin,
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

import UpdateForm from 'components/Shared/Updates/UpdateForm';
import { selectEvent } from 'containers/Event/selectors';
import { selectGroup } from 'containers/Group/selectors';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Event/messages';

export function UpdateEditPage(props) {
  useInjectReducer({ key: 'updates', reducer });
  useInjectSaga({ key: 'updates', saga });
  useInjectReducer({ key: 'field_data', reducer: fieldDataReducer });
  useInjectSaga({ key: 'field_data', saga: fieldDataSaga });

  const rs = new RouteService(useContext);
  const { intl } = props;
  useEffect(() => {
    const updatableId = dig(props, 'currentEvent', 'id');
    if (updatableId)
      props.getUpdatePrototypeBegin({ updatableId });

    return () => {
      props.updatesUnmount();
    };
  }, []);

  const partialLink = ROUTES.group.plan.events.manage.updates;
  const links = {
    index: partialLink.index.path(dig(props, 'currentGroup', 'id'), dig(props, 'currentEvent', 'id')),
  };

  return (
    <UpdateForm
      update={props.currentUpdate}
      isCommitting={props.isCommitting || props.isCommittingFieldData}
      isFetching={props.isFetching}
      links={links}
      buttonText={intl.formatMessage(messages.createupdate)}
      updateAction={payload => props.createUpdateBegin({
        ...payload,
        updatableId: dig(props, 'currentEvent', 'id')
      })}
      updateFieldDataBegin={props.updateFieldDataBegin}

      edit
    />
  );
}

UpdateEditPage.propTypes = {
  intl: intlShape,
  getUpdatePrototypeBegin: PropTypes.func.isRequired,
  createUpdateBegin: PropTypes.func.isRequired,
  updateFieldDataBegin: PropTypes.func.isRequired,
  updatesUnmount: PropTypes.func.isRequired,

  currentUpdate: PropTypes.object,
  isFetching: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isCommittingFieldData: PropTypes.bool,

  currentEvent: PropTypes.shape({
    id: PropTypes.number
  }),
  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  currentUpdate: selectUpdate(),
  currentEvent: selectEvent(),
  currentGroup: selectGroup(),
  isFetching: selectIsFetchingUpdate(),
  isCommitting: selectIsCommitting(),
  isCommittingFieldData: selectIsCommittingFieldData(),
});

const mapDispatchToProps = {
  getUpdatePrototypeBegin,
  createUpdateBegin,
  updateFieldDataBegin,
  updatesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(UpdateEditPage);
