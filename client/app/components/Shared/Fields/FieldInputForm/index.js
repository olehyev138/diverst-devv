/**
 *
 * Field Input Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { FieldArray } from 'formik';

import { withStyles } from '@material-ui/styles';
import {
  CardContent, Divider, Typography, Link
} from '@material-ui/core';

import CustomField from 'components/Shared/Fields/FieldInputs/Field';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import {createStructuredSelector} from "reselect";
import {selectEnterprise, selectPermissions} from "containers/Shared/App/selectors";
import {connect} from "react-redux";
import {mapDispatchToProps} from "components/Admin/AdminLinks";
import {permission} from "utils/permissionsHelpers";

const styles = theme => ({
  fieldInput: {
    width: '100%',
  },
});

export function FieldInputForm({ formikProps, messages, link, ...props }) {
  const { values } = formikProps;

  return (
    <React.Fragment>
      <CardContent>
        <Typography component='h6'>
          <DiverstFormattedMessage {...messages.fields} />
        </Typography>
        <Typography color='secondary' component='h2'>
          <DiverstFormattedMessage {...messages.preface} />
        </Typography>
      </CardContent>
      {values.fieldData.length !== 0
        ? (
          <FieldArray
            name='fields'
            render={_ => (
              <React.Fragment>
                {values.fieldData.filter(fd => !fd.field.private || permission(props, 'users_manage')).map((fieldDatum, i) => (
                  <div key={fieldDatum.id} className={props.classes.fieldInput}>
                    <Divider />
                    <CardContent>
                      {Object.entries(fieldDatum).length !== 0 && (
                        <CustomField
                          fieldDatum={fieldDatum}
                          fieldDatumIndex={i}
                          disabled={props.isCommitting || !(fieldDatum.field.show_on_vcard || permission(props, 'users_manage'))}
                        />
                      )}
                    </CardContent>
                  </div>
                ))}
              </React.Fragment>
            )}
          />
        ) : (
          <CardContent>
            {link ? (
              <Link
                component={WrappedNavLink}
                to={link}
              >
                <DiverstFormattedMessage {...messages.create_field} />
              </Link>
            ) : (messages.create_field && (
              <Typography>
                {' '}
                <DiverstFormattedMessage {...messages.create_field} />
              </Typography>
            ))}

          </CardContent>
        )}
    </React.Fragment>
  );
}

FieldInputForm.propTypes = {
  edit: PropTypes.bool,
  fieldData: PropTypes.array,
  formikProps: PropTypes.object,
  classes: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,

  link: PropTypes.string,
  join: PropTypes.bool,
  messages: PropTypes.shape({
    fields: PropTypes.shape({
      id: PropTypes.string
    }),
    preface: PropTypes.shape({
      id: PropTypes.string
    }),
    create_field: PropTypes.shape({
      id: PropTypes.string
    }),
    fields_save: PropTypes.shape({
      id: PropTypes.string
    }),
  }).isRequired
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  memo,
  withConnect,
  withStyles(styles),
)(FieldInputForm);
