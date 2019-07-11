/**
 *
 * News Feed Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core';
import Select from 'react-select';

import { Field, Formik, Form } from 'formik';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

export function NewsFeed(props) {
  return (
    <React.Fragment>
    </React.Fragment>
  );
}

NewsFeed.propTypes = {
};

export default compose(
  memo,
)(NewsFeed);
