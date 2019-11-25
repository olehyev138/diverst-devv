/**
 *
 * Session Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage, injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Grid, FormControlLabel, Switch, FormControl
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';

import messages from 'containers/Mentorship/Session/messages';
import { buildValues, mapFields } from 'utils/formHelpers';
import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import { DateTime } from 'luxon';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

/* eslint-disable object-curly-newline */
export function Session(props) {
  return (
    <React.Fragment>

    </React.Fragment>
  );
}

Session.propTypes = {
  sessionAction: PropTypes.func,
  session: PropTypes.object,
  currentSession: PropTypes.object,
  user: PropTypes.object,
  isCommitting: PropTypes.bool,
  buttonText: PropTypes.string,
};

export default compose(
  memo,
  injectIntl,
)(Session);
