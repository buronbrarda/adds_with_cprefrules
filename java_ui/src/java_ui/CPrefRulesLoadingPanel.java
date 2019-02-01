package java_ui;

import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.JTextPane;
import javax.swing.JLabel;
import javax.swing.BoxLayout;
import java.awt.Component;
import javax.swing.SwingConstants;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Insets;
import java.awt.GridLayout;
import javax.swing.JButton;
import javax.swing.JDialog;

import java.awt.FlowLayout;
import java.awt.BorderLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class CPrefRulesLoadingPanel extends JPanel {
	private JTextField filePathText;

	/**
	 * Create the panel.
	 */
	public CPrefRulesLoadingPanel() {
		setLayout(new BorderLayout(0, 0));
		
		JPanel panel = new JPanel();
		add(panel);
		GridBagLayout gbl_panel = new GridBagLayout();
		gbl_panel.columnWidths = new int[]{23, 158, 123, 0};
		gbl_panel.rowHeights = new int[]{23, 0, 0};
		gbl_panel.columnWeights = new double[]{0.0, 1.0, 0.0, Double.MIN_VALUE};
		gbl_panel.rowWeights = new double[]{1.0, 1.0, Double.MIN_VALUE};
		panel.setLayout(gbl_panel);
		
		JLabel intructionLabel = new JLabel("3. Define the set of CPref-Rules.");
		GridBagConstraints gbc_intructionLabel = new GridBagConstraints();
		gbc_intructionLabel.gridwidth = 2;
		gbc_intructionLabel.anchor = GridBagConstraints.WEST;
		gbc_intructionLabel.insets = new Insets(5, 5, 5, 5);
		gbc_intructionLabel.gridx = 0;
		gbc_intructionLabel.gridy = 0;
		panel.add(intructionLabel, gbc_intructionLabel);
		
		JButton defineButton = new JButton("Define");
		GridBagConstraints gbc_defineButton = new GridBagConstraints();
		gbc_defineButton.insets = new Insets(5, 0, 5, 5);
		gbc_defineButton.gridx = 2;
		gbc_defineButton.gridy = 0;
		panel.add(defineButton, gbc_defineButton);
		
		JLabel filePathLabel = new JLabel("File:");
		GridBagConstraints gbc_filePathLabel = new GridBagConstraints();
		gbc_filePathLabel.anchor = GridBagConstraints.WEST;
		gbc_filePathLabel.insets = new Insets(0, 5, 5, 5);
		gbc_filePathLabel.gridx = 0;
		gbc_filePathLabel.gridy = 1;
		panel.add(filePathLabel, gbc_filePathLabel);
		
		filePathText = new JTextField();
		filePathText.setEditable(false);
		GridBagConstraints gbc_filePathText = new GridBagConstraints();
		gbc_filePathText.fill = GridBagConstraints.HORIZONTAL;
		gbc_filePathText.insets = new Insets(0, 0, 5, 5);
		gbc_filePathText.gridx = 1;
		gbc_filePathText.gridy = 1;
		panel.add(filePathText, gbc_filePathText);
		filePathText.setColumns(10);
		
		JButton loadFileButton = new JButton("Load File");
		GridBagConstraints gbc_loadFileButton = new GridBagConstraints();
		gbc_loadFileButton.insets = new Insets(0, 0, 5, 5);
		gbc_loadFileButton.gridx = 2;
		gbc_loadFileButton.gridy = 1;
		panel.add(loadFileButton, gbc_loadFileButton);
		defineButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				new CPrefRulesEditorDialog();
			}
		});

	}

}
