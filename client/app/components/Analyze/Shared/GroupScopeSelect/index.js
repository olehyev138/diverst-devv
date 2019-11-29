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
import { Field, Formik, Form } from 'formik';

import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstSelect from 'components/Shared/DiverstSelect';

const styles = theme => ({
});

/* eslint-disable object-curly-newline */
export function GroupScopeSelectInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const groupSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  return (
    <Card>
      <Form>
        <CardContent>
          <DiverstSelect
            name='group_select'
            fullWidth
            id='group_select'
            label='Groups'
            isMulti
            options={props.groups}
            value={values.groups}
            onMenuOpen={groupSelectAction}
            onChange={v => setFieldValue('groups', v)}
            onInputChange={value => groupSelectAction(value)}
            hideHelperText
          />
        </CardContent>
        <Divider />
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
    groups: []
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => props.updateScope(values)}
    >
      {formikProps => <GroupScopeSelectInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupScopeSelect.propTypes = {
  updateScope: PropTypes.func.isRequired,
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
  groups: PropTypes.array,
  getGroupsBegin: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(GroupScopeSelect);
