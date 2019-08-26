/**
 *
 * GroupScopeSelect Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'react-select';
import { Field, Formik, Form } from 'formik';
import { FormattedMessage } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Analyze/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
});

/* eslint-disable object-curly-newline */
export function GroupScopeSelectInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            Refresh
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupScopeSelect(props) {
  const initialValues = buildValues({}, {
    from_date: { default: '' },
    to_date: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => props.updateRange(values)}
      render={formikProps => <GroupScopeSelectInner {...props} {...formikProps} />}
    />
  );
}

GroupScopeSelect.propTypes = {
  updateRange: PropTypes.func.isRequired,
};

GroupScopeSelectInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  classes: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupScopeSelect);
