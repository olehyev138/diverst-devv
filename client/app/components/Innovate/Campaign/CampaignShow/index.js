import React, {memo, useState} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import {
  Button, Card, CardActions, CardContent, Divider, Grid, TextField
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import messages from 'containers/Group/GroupMembers/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import { buildValues, mapFields } from 'utils/formHelpers';
import { DateTime } from 'luxon';

/* eslint-disable object-curly-newline */

export function CampaignShow(props) {
  const [defaultStartDate] = useState(DateTime.local().plus({ hour: 1 }));
  const [defaultEndDate] = useState(DateTime.local().plus({ hour: 2 }));
  return (
    <React.Fragment>
      <p>{dig(props.campaign, 'title')}</p>
      <br/>
      <p>{dig(props.campaign, 'description')}</p>
    </React.Fragment>
  );
}

CampaignShow.propTypes = {
  edit: PropTypes.bool,
  createCampaignBegin: PropTypes.func,
  groups: PropTypes.object,
  groupId: PropTypes.string,
  getGroupsBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
  campaign: PropTypes.object,
  campaignAction: PropTypes.func,
};




export default compose(
  memo,
)(CampaignShow);
