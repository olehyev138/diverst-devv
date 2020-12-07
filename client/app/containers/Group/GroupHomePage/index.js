import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { injectIntl, intlShape } from 'react-intl';
import reducer from 'containers/Group/reducer';
import saga from 'containers/Group/saga';

import GroupHome from 'components/Group/GroupHome';

import {
  joinGroupBegin,
  leaveGroupBegin,
  joinSubgroupsBegin
} from 'containers/Group/actions';

import { selectGroup } from 'containers/Group/selectors';
import { selectCustomText } from '../../Shared/App/selectors';

export function GroupHomePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const { intl } = props;

  return (
    <GroupHome
      currentGroup={props.currentGroup}
      joinGroup={props.joinGroupBegin}
      leaveGroup={props.leaveGroupBegin}
      joinSubgroups={props.joinSubgroupsBegin}
      intl={intl}
      customTexts={props.customTexts}
    />
  );
}

GroupHomePage.propTypes = {
  currentGroup: PropTypes.object,
  joinGroupBegin: PropTypes.func,
  leaveGroupBegin: PropTypes.func,
  joinSubgroupsBegin: PropTypes.func,
  intl: intlShape.isRequired,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  group: selectGroup(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  joinGroupBegin,
  leaveGroupBegin,
  joinSubgroupsBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  memo,
  withConnect,
)(GroupHomePage);
